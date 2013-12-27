---
layout:     post
title:      Ubuntu 10.10 Mise à jour impossible
---

Madâme a un problème de mise à jour ces derniers temps, avec un beau signe “sens interdit” sur son écran.La mise à jour des paquets affiche cette erreur:

Lecture des listes de paquets... Erreur 
{% highlight sh %}
!E: Encountered a section with no Package: headerE: Problem with MergeList /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_maverick-updates_main_binary-i386_PackagesE: Les listes de paquets ou le fichier « status » ne peuvent être analysés ou lus.
{% endhighlight %}
Dans un terminal, taper ces commandes

{% highlight sh %}
sudo rm /var/lib/apt/lists/* -vfsudo apt-get update
{% endhighlight %}
Et voilà, la liste des paquets est actualisée, et Madâme peut à nouveau mettre son système à joursource