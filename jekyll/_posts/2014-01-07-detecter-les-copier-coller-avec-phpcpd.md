---
layout:     post
title:      Détecter les copier/coller avec phpcpd
lang: fr
categories: programmation
---

[PHP Copy Paste Detector (PHPCPD)][phpcpd] detecte si les mêmes lignes de code sont à plusieurs endroits dans la source d'une application.

A l'origine d'un copier/coller de code, il y a une application mal pensée et mal conçue. D'autre part, c'est systématiquement un cauchemar pour la [Maintenabilité].

### Installation

[phpcpd] est disponible via composer:

{% highlight bash %}
$ php composer.phar require --dev \
                    sebastian/phpcpd:"*@stable"
{% endhighlight %}

### Utilisation

Pour détecter les copier/coller dans les fichiers php ou twig d'une appli symfony:

{% highlight bash %}
$ ./bin/phpcpd --progress --names *.php,*.twig src/
phpcpd 0.2.1-2-g413896f by Sebastian Bergmann.

 83/83 [============================] 100%

0.00% duplicated lines out of 6620 total lines of code.

Time: 148 ms, Memory: 6.50Mb
{% endhighlight %}

[phpcpd]: https://github.com/sebastianbergmann/phpcpd
[Maintenabilité]: http://fr.wikipedia.org/wiki/Maintenabilit%C3%A9
