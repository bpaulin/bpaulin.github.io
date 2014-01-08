---
layout:     post
title:      Volume du son d’un Dell Inspiron 9400 sous ubuntu
categories: linux
---

Après l’installation d’un ubuntu tout frais sur le portable, la gestion du son est assez rock’n'roll depuis quelques versions.

Pour résumer, le portable voit 2 cas de figures:
* moins de 20%: pas de son
* plus de 20%: à fond

Pour régler ça, il faut éditer le fichier /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common

{% highlight sh %}
gksudo gedit /usr/share/pulseaudio/alsa-mixer/paths/analog-output.conf.common
{% endhighlight %}
Et remplacer ce bloc (vers la fin du fichier)

{% highlight sh %}
[Element PCM]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right
{% endhighlight %}

Par ces lignes

{% highlight sh %}
[Element Master]
switch = mute
volume = ignore
[Element PCM]
switch = mute
volume = merge
override-map.1 = all
override-map.2 = all-left,all-right
[Element LFE]
switch = mute
volume = ignore
{% endhighlight %}

[source](http://doc.ubuntu-fr.org/dell_inspiron_9400#carte_son)