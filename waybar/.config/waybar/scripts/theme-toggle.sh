#!/bin/bash
# System-wide light/dark switch for waybar.
#   theme-toggle.sh          -> print waybar JSON for the current mode
#   theme-toggle.sh toggle   -> flip mode, then refresh the waybar module
#
# Covers: color-scheme (libadwaita/GTK4, Electron, Firefox/Zen, WebKit apps like WARP),
# GTK3 theme, icon theme, GTK settings.ini, Kvantum + qt5ct/qt6ct for Qt apps.

SIGNAL=8

DARK_GTK="catppuccin-mocha-blue-standard+default"
LIGHT_GTK="Adwaita"
DARK_ICONS="Papirus-Dark"
LIGHT_ICONS="Papirus-Light"
DARK_KV="KvGnomeDark"
LIGHT_KV="KvGnome"
DARK_QT5_COLORS="/usr/share/qt5ct/colors/darker.conf"
DARK_QT6_COLORS="/usr/share/qt6ct/colors/catppuccin-mocha-blue.conf"
LIGHT_QT5_COLORS="/usr/share/qt5ct/colors/airy.conf"
LIGHT_QT6_COLORS="/usr/share/qt6ct/colors/airy.conf"

current_mode() {
    if [[ "$(gsettings get org.gnome.desktop.interface color-scheme)" == "'prefer-dark'" ]]; then
        echo dark
    else
        echo light
    fi
}

set_ini() {  # file key value
    [[ -f "$1" ]] && sed -i "s|^$2=.*|$2=$3|" "$1"
}

apply() {
    local mode=$1 scheme gtk icons kv qt5 qt6 prefer
    if [[ $mode == dark ]]; then
        scheme=prefer-dark; gtk=$DARK_GTK; icons=$DARK_ICONS; kv=$DARK_KV
        qt5=$DARK_QT5_COLORS; qt6=$DARK_QT6_COLORS; prefer=1
    else
        scheme=prefer-light; gtk=$LIGHT_GTK; icons=$LIGHT_ICONS; kv=$LIGHT_KV
        qt5=$LIGHT_QT5_COLORS; qt6=$LIGHT_QT6_COLORS; prefer=0
    fi

    # Portal-aware apps (switch live)
    gsettings set org.gnome.desktop.interface color-scheme "$scheme"
    gsettings set org.gnome.desktop.interface gtk-theme "$gtk"
    gsettings set org.gnome.desktop.interface icon-theme "$icons"

    # GTK3/4 settings.ini (apps started later)
    for v in 3.0 4.0; do
        f="$HOME/.config/gtk-$v/settings.ini"
        set_ini "$f" gtk-theme-name "$gtk"
        set_ini "$f" gtk-icon-theme-name "$icons"
        set_ini "$f" gtk-application-prefer-dark-theme "$prefer"
    done

    # Qt (apps pick this up on next launch)
    set_ini "$HOME/.config/Kvantum/kvantum.kvconfig" theme "$kv"
    set_ini "$HOME/.config/qt5ct/qt5ct.conf" color_scheme_path "$qt5"
    set_ini "$HOME/.config/qt6ct/qt6ct.conf" color_scheme_path "$qt6"
    set_ini "$HOME/.config/qt5ct/qt5ct.conf" icon_theme "$icons"
    set_ini "$HOME/.config/qt6ct/qt6ct.conf" icon_theme "$icons"
}

case "$1" in
    toggle)
        if [[ $(current_mode) == dark ]]; then apply light; else apply dark; fi
        pkill -RTMIN+$SIGNAL waybar
        ;;
    dark|light)
        apply "$1"
        pkill -RTMIN+$SIGNAL waybar
        ;;
    *)
        if [[ $(current_mode) == dark ]]; then
            printf '{"text":"󰖔","tooltip":"Dark mode — click for light","class":"dark"}\n'
        else
            printf '{"text":"󰖨","tooltip":"Light mode — click for dark","class":"light"}\n'
        fi
        ;;
esac
