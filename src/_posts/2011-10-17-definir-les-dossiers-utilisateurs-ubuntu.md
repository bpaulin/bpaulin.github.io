---
title: Définir les dossiers utilisateurs
date: 2011-10-17
summary: ' '
---

Ubuntu (ou gnome?) définit des dossiers qui seront assignés au bureau, à la musique, aux téléchargments, etc.

Le chemin de ces dossiers est indiqué dans ~/.config/user-dirs

Par exemple, chez moi

```bash
$ nano .config/user-dirs.dirs
```

```bash
# This file is written by xdg-user-dirs-update
# If you want to change or add directories, just edit the line you're
# interested in. All local changes will be retained on the next run
# Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
# absolute path. No other format is supported.
#
XDG_DESKTOP_DIR="$HOME/Bureau"
XDG_DOWNLOAD_DIR="$HOME/Téléchargements"
XDG_TEMPLATES_DIR="$HOME/Modèles"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Musique"
XDG_PICTURES_DIR="$HOME/Images"
XDG_VIDEOS_DIR="$HOME/Vidéos"
```


[source](http://www.howtogeek.com/howto/17752/use-any-folder-for-your-ubuntu-desktop-even-a-dropbox-folder/)
