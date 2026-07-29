#!/usr/bin/env python3
import subprocess
import json
import time
import sys
import os
import threading
import fcntl
import select
import html

os.environ["PYTHONUNBUFFERED"] = "1"

# Make stdout non-blocking so we never stall waiting for waybar to read
fd = sys.stdout.fileno()
flags = fcntl.fcntl(fd, fcntl.F_GETFL)
fcntl.fcntl(fd, fcntl.F_SETFL, flags | os.O_NONBLOCK)

SCROLL_WIDTH = 30
SCROLL_PAD = "   "
HIDE_AFTER = 90
PLAYER_FILE = "/tmp/waybar-media-active-player"
WAVE_FRAMES = [
    "\u2581\u2583\u2585\u2583",
    "\u2582\u2584\u2584\u2582",
    "\u2583\u2585\u2583\u2581",
    "\u2584\u2584\u2582\u2582",
    "\u2585\u2583\u2581\u2583",
    "\u2584\u2582\u2582\u2584",
    "\u2583\u2581\u2583\u2585",
    "\u2582\u2582\u2584\u2584",
]

# Shared state between threads
lock = threading.Lock()
shared = {
    "title": "",
    "artist": "",
    "status": None,
    "player": None,
    "last_playing_time": 0,
    "last_playing_player": None,
}


def run(cmd):
    try:
        return subprocess.run(cmd, capture_output=True, text=True, timeout=2).stdout.strip()
    except Exception:
        return ""


def pick_player(players, last_playing_player):
    playing = [p for p in players if p["status"] == "Playing"]
    paused = [p for p in players if p["status"] == "Paused"]

    if playing:
        for p in playing:
            if p["name"] == last_playing_player:
                return p, "Playing"
        return playing[0], "Playing"

    if last_playing_player:
        for p in paused:
            if p["name"] == last_playing_player:
                return p, "Paused"

    if paused:
        return paused[0], "Paused"

    if last_playing_player:
        for p in players:
            if p["name"] == last_playing_player:
                return p, p["status"]

    return None, None


def data_fetcher():
    """Background thread that fetches player data without blocking animation."""
    last_good = 0

    while True:
        try:
            raw = run(["playerctl", "-a", "metadata", "--format",
                       "{{playerName}}|||{{status}}|||{{title}}|||{{artist}}"])
            players = []
            if raw:
                for line in raw.split("\n"):
                    parts = line.split("|||")
                    if len(parts) >= 4:
                        players.append({"name": parts[0], "status": parts[1],
                                       "title": parts[2], "artist": parts[3]})

            with lock:
                lpp = shared["last_playing_player"]

            active, status = pick_player(players, lpp)

            if active:
                last_good = time.time()
                fresh = run(["playerctl", "-p", active["name"], "metadata",
                             "--format", "{{title}}|||{{artist}}"])
                if fresh and "|||" in fresh:
                    fparts = fresh.split("|||")
                    title, artist = fparts[0], fparts[1]
                else:
                    title, artist = active["title"], active["artist"]

                with lock:
                    shared["title"] = title
                    shared["artist"] = artist
                    shared["status"] = status
                    shared["player"] = active["name"]
                    if status == "Playing":
                        shared["last_playing_player"] = active["name"]
                        shared["last_playing_time"] = time.time()

                try:
                    with open(PLAYER_FILE, "w") as f:
                        f.write(active["name"])
                except Exception:
                    pass
            else:
                # FIX: grace period — keep current state for 5s during transient
                # D-Bus gaps (track changes, Spotify hiccups) so the wave animation
                # continues instead of switching to paused/stopped immediately.
                if time.time() - last_good > 5:
                    with lock:
                        shared["status"] = None
                        shared["player"] = None

        except Exception:
            pass

        time.sleep(0.5)


# Start background data fetcher
t = threading.Thread(target=data_fetcher, daemon=True)
t.start()

# Give it a moment to get initial data
time.sleep(0.3)

offset = 0
wave_frame = 0
scroll_tick = 0
prev_full_text = ""


def emit(text, cls):
    """Non-blocking write — drops frame if waybar isn't ready to read."""
    line = json.dumps({"text": text, "class": cls}) + "\n"
    try:
        os.write(fd, line.encode())
    except BlockingIOError:
        pass  # Pipe full, skip this frame


while True:
    try:
        with lock:
            title = shared["title"]
            artist = shared["artist"]
            status = shared["status"]
            last_playing_time = shared["last_playing_time"]

        now = time.time()

        if not status or (
            status != "Playing" and now - last_playing_time > HIDE_AFTER
        ):
            if now - last_playing_time > HIDE_AFTER or last_playing_time == 0:
                emit("", "stopped")
                offset = 0
                time.sleep(0.5)
                continue

        if not title:
            emit("", "stopped")
            time.sleep(0.5)
            continue

        # FIX: status can be None during the grace period window — treat as Paused
        # so status.lower() below never crashes.
        if not status:
            status = "Paused"

        full_text = f"{title} - {artist}" if artist else title

        if full_text != prev_full_text:
            offset = 0
            prev_full_text = full_text

        scroll_tick += 1
        if scroll_tick % 10 == 0 and len(full_text) > SCROLL_WIDTH:
            offset = (offset + 1) % (len(full_text) + len(SCROLL_PAD))

        if len(full_text) > SCROLL_WIDTH:
            padded = full_text + SCROLL_PAD + full_text
            display = padded[offset:offset + SCROLL_WIDTH]
        else:
            display = full_text

        if status == "Playing":
            bars = WAVE_FRAMES[wave_frame % len(WAVE_FRAMES)]
            icon = f"<span rise='2000'>{bars}</span>"
            wave_frame += 1
        else:
            icon = "<span font_size='12000' rise='-1000'>&#x23f8;</span>"

        emit(f"{icon} {html.escape(display)}", status.lower())

    except Exception:
        pass

    time.sleep(0.1)
