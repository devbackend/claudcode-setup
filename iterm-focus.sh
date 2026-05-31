#!/bin/bash
# Focus a specific iTerm2 pane (by TERM_SESSION_ID) and tmux pane (by pane ID + socket)
ITERM_SESSION="$1"
TMUX_PANE_ID="$2"
TMUX_SOCKET="$3"

# Bring iTerm2 window to front
if [ -n "$ITERM_SESSION" ]; then
  osascript <<EOF
tell application "iTerm2"
  activate
  repeat with w in windows
    repeat with t in tabs of w
      repeat with s in sessions of t
        if unique ID of s is "$ITERM_SESSION" then
          select s
          return
        end if
      end repeat
    end repeat
  end repeat
end tell
EOF
else
  osascript -e 'tell application "iTerm2" to activate'
fi

# Switch tmux pane
if [ -n "$TMUX_PANE_ID" ] && [ -n "$TMUX_SOCKET" ]; then
  sleep 0.1
  tmux -S "$TMUX_SOCKET" select-pane -t "$TMUX_PANE_ID"
fi
