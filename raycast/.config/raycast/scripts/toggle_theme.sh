#!/bin/bash
# @raycast.schemaVersion 1
# @raycast.title Toggle Dev Theme
# @raycast.mode silent

MODE=$(defaults read -g AppleInterfaceStyle 2>/dev/null)

LIGHT_WALL="$HOME/dotfiles/wallpapers/solarized_video_game.png"
DARK_WALL="$HOME/dotfiles/wallpapers/nord_dark_fish.png"

if [ "$MODE" = "Dark" ]; then
  # switch to LIGHT
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'
  osascript << EOF
tell application "System Events"
  set desktopPicture to POSIX file "$LIGHT_WALL"
  set the picture of every desktop to desktopPicture
end tell
EOF
else
  # switch to DARK
  osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
  osascript << EOF
tell application "System Events"
  set desktopPicture to POSIX file "$DARK_WALL"
  set the picture of every desktop to desktopPicture
end tell
EOF
fi
