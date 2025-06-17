#!/bin/bash
# Script Animasi Border Dunst V3 - Menggunakan 'dispatch setprop'

angle=0
color1="rgb(0d47a1)"
color2="rgb(90caf9)"

# Loop tak terbatas untuk terus mencoba mengubah properti
while true; do
  gradient_string="$color1 $color2 $color1 $angle""deg"

  # PERINTAH BARU YANG BENAR:
  # Menggunakan 'dispatch setprop' dengan sintaks:
  # dispatch setprop <property> <value> <window>
  hyprctl dispatch setprop "bordercolor" "$gradient_string" "class:^(Dunst)$"

  angle=$(((angle + 5) % 360))
  sleep 0.02
done
