# Remote control volume for OPPO HA-1

I'm using it in sway like this:

```
Ctrl+Shift+XF86AudioRaiseVolume exec "$HOME/.config/personal/oppo_controller/env/bin/python" \
    "$HOME/.config/personal/oppo_controller/main.py" --up && \
    echo 100 > $SWAYSOCK.wob
Ctrl+Shift+XF86AudioLowerVolume exec "$HOME/.config/personal/oppo_controller/env/bin/python" \
    "$HOME/.config/personal/oppo_controller/main.py" --down && \
    echo 100 > $SWAYSOCK.wob
Ctrl+Shift+XF86AudioMute exec "$HOME/.config/personal/oppo_controller/env/bin/python" \
    "$HOME/.config/personal/oppo_controller/main.py" --onoff && \
    echo 100 > $SWAYSOCK.wob
```
