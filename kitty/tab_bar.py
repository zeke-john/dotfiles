# Custom tab bar: rectangular tabs that always split the full bar width
# equally (2 tabs = 50/50, 3 = 33/33/33, ...), flush against each other,
# titles centered with a 1-cell margin. Used via `tab_bar_style custom`.
#
# Close a tab with middle-click (kitty built-in) or ctrl+shift+q.

from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_tab_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if extra_data.for_layout:
        # Claim maximum length so kitty's layout pass gives every tab an
        # equal share of the bar instead of sizing tabs to their titles.
        screen.draw(" " * max_tab_length)
        return screen.cursor.x

    width = (screen.columns - before) if is_last else max_tab_length
    avail = width - 2  # keep a 1-cell margin on each side of the title

    if avail < 1:
        screen.draw(" " * max(width, 0))
        return screen.cursor.x

    title = tab.title
    if tab.num_windows > 1:
        title += f" :{tab.num_windows}:"
    if len(title) > avail:
        title = title[: max(avail - 1, 0)] + "…"

    pad = avail - len(title)
    left = pad // 2
    screen.draw(" " * (left + 1) + title + " " * (pad - left + 1))
    return screen.cursor.x
