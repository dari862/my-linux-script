#!/usr/bin/env bash
Theme_name="$1"
PDIR="$HOME/.config/polybar"
RDIR="$HOME/.config/polybar/Rofi/$Theme_name"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $RDIR/styles.rasi \
<<< " forest| grayblocks| hack| material| pwidgets| shades| shapes| Titus|")"
            case "$MENU" in
                                *forest) echo "forest" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *grayblocks) echo "grayblocks" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *hack) echo "hack" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *material) echo "material" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *pwidgets) echo "pwidgets" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *shades) echo "shades" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *shapes) echo "shapes" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
                                *Titus) echo "Titus" > "$PDIR"/Picked_Theme && "$PDIR"/launch.sh & ;; 
            esac
