#!/bin/bash

volume_step=1
brightness_step=5
max_volume=100
notification_timeout=1000
download_album_art=true
show_album_art=true
show_music_in_volume_indicator=true

function get_volume {
  pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]{1,3}(?=%)' | head -1
}

function get_mute {
  pactl get-sink-mute @DEFAULT_SINK@ | grep -Po '(?<=Mute: )(yes|no)'
}

function get_brightness {
  brightnessctl | grep -Po '[0-9]{1,3}' | head -n 1
}

function get_volume_icon {
  volume=$(get_volume)
  mute=$(get_mute)
  if [ "$volume" -eq 0 ] || [ "$mute" == "yes" ]; then
    volume_icon=""
  elif [ "$volume" -lt 50 ]; then
    volume_icon=" "
  else
    volume_icon=" "
  fi
}

function get_brightness_icon {
  brightness_icon=""
}

# Dynamically select the player that is playing
function get_active_player {
  players=$(playerctl -l 2>/dev/null)
  for player in $players; do
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [[ "$status" == "Playing" ]]; then
      echo "$player"
      return
    fi
  done
  echo "" # Return empty if nothing is playing
}

function get_album_art {
  player=$(get_active_player)
  [ -z "$player" ] && album_art=""
  url=$(playerctl -p "$player" -f "{{mpris:artUrl}}" metadata 2>/dev/null)

  if [[ $url == "file://"* ]]; then
    album_art="${url/file:\/\//}"
  elif [[ $url == http* ]] && [[ $download_album_art == "true" ]]; then
    filename="$(echo "$url" | sed 's/.*\///')"
    if [ ! -f "/tmp/$filename" ]; then
      wget -q -O "/tmp/$filename" "$url"
    fi
    album_art="/tmp/$filename"
  else
    album_art=""
  fi
}

function show_volume_notif {
  volume=$(get_volume)
  mute=$(get_mute)
  get_volume_icon

  if [[ $show_music_in_volume_indicator == "true" ]]; then
    player=$(get_active_player)
    if [ -n "$player" ]; then
      current_song=$(playerctl -p "$player" -f "{{title}} - {{artist}}" metadata 2>/dev/null)
      [ -z "$current_song" ] && current_song="Unknown Media"
    else
      current_song=""
    fi

    if [[ $show_album_art == "true" ]]; then
      get_album_art
    fi

    notify-send -t $notification_timeout \
      -h string:x-dunst-stack-tag:volume_notif \
      -h int:value:$volume \
      -i "$album_art" "$volume_icon $volume%" "$current_song"
  else
    notify-send -t $notification_timeout \
      -h string:x-dunst-stack-tag:volume_notif \
      -h int:value:$volume "$volume_icon $volume%"
  fi
}

function show_music_notif {
  player=$(get_active_player)
  if [ -z "$player" ]; then
    notify-send -t $notification_timeout "No media playing"
    return
  fi

  song_title=$(playerctl -p "$player" -f "{{title}}" metadata 2>/dev/null)
  song_artist=$(playerctl -p "$player" -f "{{artist}}" metadata 2>/dev/null)
  song_album=$(playerctl -p "$player" -f "{{album}}" metadata 2>/dev/null)

  [ -z "$song_title" ] && song_title="Unknown Title"
  [ -z "$song_artist" ] && song_artist="Unknown Artist"
  [ -z "$song_album" ] && song_album=""

  if [[ $show_album_art == "true" ]]; then
    get_album_art
  fi

  notify-send -t $notification_timeout \
    -h string:x-dunst-stack-tag:music_notif \
    -i "$album_art" "$song_title" "$song_artist - $song_album"
}

function show_brightness_notif {
  brightness=$(get_brightness)
  get_brightness_icon
  notify-send -t $notification_timeout \
    -h string:x-dunst-stack-tag:brightness_notif \
    -h int:value:$brightness "$brightness_icon $brightness%"
}

case $1 in
volume_up)
  pactl set-sink-mute @DEFAULT_SINK@ 0
  volume=$(get_volume)
  if [ $(("$volume" + "$volume_step")) -gt $max_volume ]; then
    pactl set-sink-volume @DEFAULT_SINK@ $max_volume%
  else
    pactl set-sink-volume @DEFAULT_SINK@ +$volume_step%
  fi
  show_volume_notif
  ;;

volume_down)
  pactl set-sink-volume @DEFAULT_SINK@ -$volume_step%
  show_volume_notif
  ;;

volume_mute)
  pactl set-sink-mute @DEFAULT_SINK@ toggle
  show_volume_notif
  ;;

brightness_up)
  brightnessctl set ${brightness_step}%+
  show_brightness_notif
  ;;

brightness_down)
  brightnessctl set ${brightness_step}%-
  show_brightness_notif
  ;;

next_track)
  player=$(get_active_player)
  [ -n "$player" ] && playerctl -p "$player" next
  sleep 0.5 && show_music_notif
  ;;

prev_track)
  player=$(get_active_player)
  [ -n "$player" ] && playerctl -p "$player" previous
  sleep 0.5 && show_music_notif
  ;;

play_pause)
  player=$(get_active_player)
  [ -n "$player" ] && playerctl -p "$player" play-pause
  show_music_notif
  ;;
esac
