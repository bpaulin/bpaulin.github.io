---
title: Nous sommes si petits
date: 2016-05-12
summary: ' '
---

Ce script me permet de revasser de temps en temps. Une simple commande pour voyager vite et loin...

Il affiche a quelle distance nous sommes du soleil, et à quelle vitesse la terre est en train de tourner autour.

```bash
#!/bin/bash
export LC_NUMERIC="en_US.UTF-8"
DAY=`date +%s`-`date -d 4-Jan +%s`
DISTANCE=$(printf %.0f `bc -l <<<"149597870.691*(1-.01672*c(($DAY)/5022635.5296))"`)
printf "The sun is %'d km away" $DISTANCE
UA=$(printf %.3f `bc -l <<<"$DISTANCE/149597870.700"`)
printf " ( %.3f UA )\n" $UA
SPEED=$(printf %.0f `bc -l <<<"sqrt(1.327*10^20*(2/($DISTANCE*1000)-1/(1.496*10^11)))"`)
printf "Earth is moving at %'d m/s\n" $SPEED
```
