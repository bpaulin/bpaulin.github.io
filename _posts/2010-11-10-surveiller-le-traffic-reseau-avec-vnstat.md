---
layout:     post
title:      Surveiller le trafic réseau avec vnstat
lang: fr
categories: linux
---

Le débit de ma connexion s'est récemment effondré. J'ai voulu savoir si une des machines en était responsable, en monopolisant la bande passante.
Pour ça, installer vnstat
```sh 
$ sudo apt-get install vnstat
``` 
Pour avoir le trafic en temps réel:

```sh 
$ vnstat -l -i eth0
Monitoring eth0...    (press CTRL-C to stop)
rx:      360 kbit/s    64 p/s
tx:       88 kbit/s    71 p/s
``` 
* -l: affiche le trafic en temps réel
* -i eth0: sélectionne l'interface eth0 (inutile ici car eth0 est l'interface sélectionnée par défaut)
Dans un 1er temps, les infos sont affichées en temps réel

Puis après l'arrêt, vnstat affiche le résumé de la session
```sh 
                           rx         |       tx
--------------------------------------+------------------
  bytes                        0 KiB  |           1 KiB
--------------------------------------+------------------
          max               0 kbit/s  |        4 kbit/s
      average            0.00 kbit/s  |     0.44 kbit/s
          min               0 kbit/s  |        0 kbit/s
--------------------------------------+------------------
  packets                          3  |               6
--------------------------------------+------------------
          max                  1 p/s  |           2 p/s
      average                  0 p/s  |           0 p/s
          min                  0 p/s  |           0 p/s
--------------------------------------+------------------
 time                    18 seconds
``` 