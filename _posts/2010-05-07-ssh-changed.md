---
layout:     post
title:      REMOTE HOST IDENTIFICATION HAS CHANGED
---

Après la réinstallation de mon serveur, j’ai ce message bien accueillant si j’essaye de m’y connecter en ssh

{% highlight sh %}
$ ssh user@ipduserver
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that the RSA host key has just been changed.
{% endhighlight %}
Une nouvelle clé a été générée, différente de celle que le client avait enregistré. Pour régler ça, taper sur le poste client

{% highlight sh %}
$ ssh-keygen -R ipduserver
{% endhighlight %}
et lancer la connexion ssh à nouveau

{% highlight sh %}
$ ssh user@ipduserver
{% endhighlight %}