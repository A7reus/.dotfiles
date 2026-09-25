while inotifywait -e close_write $HOME/.config/waybar; do killall -SIGUSR2 waybar; done
