#!/bin/bash
stamp=$(date "+%-I:%M %p, %b %-d" | tr '[:upper:]' '[:lower:]')
text="<span color='#5C6066'>[</span> ${stamp} <span color='#5C6066'>]</span>"
today=$(date "+%-d")
cal=$(cal | sed "s/\b${today}\b/<span color='#c5c9c7'><b>${today}<\/b><\/span>/")
cal=$(echo "$cal" | sed ':a;N;$!ba;s/\n/\\n/g')
echo "{\"text\": \"${text}\", \"tooltip\": \"<tt>${cal}</tt>\"}"
