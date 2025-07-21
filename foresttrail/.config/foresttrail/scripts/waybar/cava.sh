#!/bin/bash

bar="▁▂▃▄▅▆▇█"
dict="s/;//g;"

# Build bar lookup dictionary
i=0
while [ $i -lt ${#bar} ]; do
    dict="${dict}s/$i/${bar:$i:1}/g;"
    i=$((i + 1))
done

# Run cava and convert output
cava -p /home/bean/.config/cava/config | while read -r line; do
    echo "$line" | sed "$dict" | awk '{print "{\"text\": \"" $0 "\"}"}'
done

