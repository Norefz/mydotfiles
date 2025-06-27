#!/bin/bash

# Script untuk menganimasikan border Dunst di Hyprland
# dengan mengubah variabel sudut secara terus-menerus.

# Inisialisasi sudut awal
angle=0

# Memulai loop tak terbatas
while true; do
  # Menggunakan hyprctl untuk mengubah nilai variabel 'dunstBorderAngle'
  # yang sudah kita definisikan di hyprland.conf.
  # 'int:' adalah tipe data yang kita kirim (integer).
  hyprctl setvar 'int:dunstBorderAngle' $angle

  # Menambahkan nilai sudut.
  # Anda bisa mengubah `+ 5` menjadi lebih besar (putaran lebih cepat/patah-patah)
  # atau lebih kecil (putaran lebih lambat/halus).
  angle=$(((angle + 5) % 360))

  # Jeda antar pembaruan untuk mengontrol kecepatan animasi.
  # Nilai lebih kecil = animasi lebih cepat. Contoh: 0.01
  # Nilai lebih besar = animasi lebih lambat. Contoh: 0.1
  sleep 0.02
done
