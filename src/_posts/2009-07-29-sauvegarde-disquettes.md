---
title: Sauvegarde de disquettes
date: 2009-07-29
summary: ' '
---

Script pour sauvegarder des disquettes sur son son disque dur

```bash
#!/bin/bash
cd disquette
i=1
#montage de la disquette
while true
do
    echo "Insere la disquette $i et appuie sur une touche"
    read prout
    sudo mount -t vfat -o iocharset=utf8,codepage=850 /dev/fd0 /media/floppy0
    mkdir $i
    cp -r /media/floppy0/* $i
    echo "copie finie"
    sudo umount /media/floppy0
    i=`expr $i + 1`
done
```
