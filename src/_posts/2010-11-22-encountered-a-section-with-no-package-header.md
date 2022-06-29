---
title: Ubuntu 10.10 Mise à jour impossible
date: 2010-11-22
summary: ' '
---

En cas d'erreur

```bash
Lecture des listes de paquets... Erreur
!E: Encountered a section with no Package: headerE: Problem with MergeList /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_maverick-updates_main_binary-i386_PackagesE: Les listes de paquets ou le fichier « status » ne peuvent être analysés ou lus.
```

Dans un terminal, taper ces commandes

```bash
sudo rm /var/lib/apt/lists/* -vfsudo apt-get update
```
