---
layout:     post
title:      Ubuntu 10.10 Mise à jour impossible
categories: linux
---

En cas d'erreur

{% highlight sh %}
Lecture des listes de paquets... Erreur 
!E: Encountered a section with no Package: headerE: Problem with MergeList /var/lib/apt/lists/fr.archive.ubuntu.com_ubuntu_dists_maverick-updates_main_binary-i386_PackagesE: Les listes de paquets ou le fichier « status » ne peuvent être analysés ou lus.
{% endhighlight %}

Dans un terminal, taper ces commandes

{% highlight sh %}
sudo rm /var/lib/apt/lists/* -vfsudo apt-get update
{% endhighlight %}