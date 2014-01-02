---
layout:     post
title:      REMOTE HOST IDENTIFICATION HAS CHANGED
categories: réseau linux
---

{% highlight sh %}
$ ssh user@ipduserver
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
Someone could be eavesdropping on you right now (man-in-the-middle attack)!
It is also possible that the RSA host key has just been changed.
{% endhighlight %}

Taper sur le poste client

{% highlight sh %}
$ ssh-keygen -R ipduserver
{% endhighlight %}

Lancer la connexion ssh à nouveau

{% highlight sh %}
$ ssh user@ipduserver
{% endhighlight %}