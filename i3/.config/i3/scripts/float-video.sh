#!/bin/bash
# Float current window and resize to small video size in bottom right

# Get screen dimensions
screen_width=$(xrandr | grep -oP '(?<=current )\d+' | head -1)
screen_height=$(xrandr | grep -oP '(?<=current )\d+ x \d+' | grep -oP '\d+$')

# Calculate video window size (small 16:9 ratio)
# Calculate based on height to avoid width minimum size issues
# Using about 25% of screen height for a small video
video_height=$((screen_height / 4))
video_width=$((video_height * 16 / 9))

# Calculate position for bottom right with small padding
padding=20
pos_x=$((screen_width - video_width - padding))
pos_y=$((screen_height - video_height - padding*3))

# Make window floating, resize and position it
i3-msg "floating enable, resize set ${video_width} ${video_height}, move position ${pos_x} ${pos_y}"
