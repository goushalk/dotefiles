path=$1

swww img "${path}" --transition-type grow --transition-duration 1 && wal -i "$path"
