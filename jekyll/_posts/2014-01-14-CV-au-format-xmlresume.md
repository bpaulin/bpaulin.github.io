---
layout:     post
title:      CV au format XMLRésumé
categories: vie
---

## Le problème

Mon CV est depuis longtemps édité dans le format odt et envoyé en pdf, le plus pratique et le plus rapide à mettre en place.

Le problème est que je veux maintenant un CV intégré sur ce site, ce qui élimine le format odt. Quite à changer de format, j'ai listé mes critères de choix:

- toutes les sources doivent être versionnées et éditables avec un simple éditeur de texte
- le fond et la forme doivent être strictement séparés
- je veux que les modifications du fond soient répercutées le plus automatiquement possible sous ces formes:
   - html à intégrer sur ce site
   - html indépendante
   - texte brute (pour relecture)
   - pdf
- _si possible, je voudrais jouer un peu avec le format xml_

## Le choix

Après quelques recherches, 2 format semblent correspondre:

- Le projet XMLRésuméLibrary, qui a définit un format de données en XML et permet un export via XLST. Ce projet est à l'abandon.
- Europass est un projet de la communauté européenne, actif et apparemment beaucoup utilisé

Europass est très complet et (donc) très complexe. XMLRésuméLibrary, du moins le format xml associé, est beaucoup plus simple mais offre les fonctions voulues.

La documentation d'europass est... incompréhensible. Je ne suis vraiment pas un expert du xml mais chaque lien, chaque lecture me perdait un peu plus.

La [documentation] de XMLRésumé est extrêmement claire. Le [DTD] du XML est parfaitement commenté et peut se suffire a lui-même; Le site offre des exemples clairs et apporte des suppléments d'information sur les éléments du XML

**Dans le doute, utiliser la solution la plus simple.** Ca sera donc [XMLRésuméLibrary] en attendant l'éventuel besoin d'[Europass]

## Outil et commande

Pour valider le xml:

{% highlight bash %}
$ xmllint --noout --valid --dtdvalid http://xmlresume.sourceforge.net/dtd/resume.dtd /chemin/du/cv.xml 
{% endhighlight %}

Pour générer le html:

{% highlight bash %}
$ xsltproc --novalid -o /chemin/du/fichier.html /chemin/du/fichier.xsl /chemin/du/cv.xml 
{% endhighlight %}

j'utilise [grunt-xsltproc] pour la génération

## Le résultat

Une feuille de style ([visible ici](https://github.com/bpaulin/bpaulin.net/blob/master/cv/cv-html.xsl)) transforme mon cv au format xml ([visible ici](https://github.com/bpaulin/bpaulin.net/blob/master/cv/brunopaulin.xml)) pour générer après chaque modification la page [A propos](/apropos/)

[grunt-xsltproc]: https://npmjs.org/package/grunt-xsltproc
[XMLRésuméLibrary]: http://xmlresume.sourceforge.net/
[documentation]: http://xmlresume.sourceforge.net/user-guide/index.html
[DTD]: http://xmlresume.sourceforge.net/dtd/resume.dtd
[Europass]: http://interop.europass.cedefop.europa.eu/data-model/xml-resources/