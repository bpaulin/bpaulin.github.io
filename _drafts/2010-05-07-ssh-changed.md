---
layout:     post
title:      REMOTE HOST IDENTIFICATION HAS CHANGED
lang: fr
categories: linux
---

```sh 
$ ssh user@ipduserver
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that the RSA host key has just been changed.
``` 

Taper sur le poste client

```sh 
$ ssh-keygen -R ipduserver
``` 

Lancer la connexion ssh à nouveau

```sh 
$ ssh user@ipduserver
``` 