---
title: CV au format XMLRésumé
date: 2014-01-07
summary: ' '
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

## Les outils

* [xmllint]  (installé par le paquet [libxml2-utils](apt://libxml2-utils)) valide le xml source.
* [xsltproc]  (installé par le paquet [xsltproc](apt://xsltproc)) réalise la transformation en html et vcard.
* [Apache FOP]  (installé par le paquet [fop](apt://fop)) réalise la transformation en pdf.

## Les commandes

Valider le xml:

```bash
$ xmllint --noout --postvalid --dtdvalid http://xmlresume.sourceforge.net/dtd/resume.dtd cv/brunopaulin.xml
```

Générer le html:

```bash
$ xsltproc --novalid -o jekyll/_includes/cv.html cv/cv-html.xsl cv/brunopaulin.xml
```

Générer la vcard:

```bash
$ xsltproc --novalid -o jekyll/apropos/brunopaulin.vcf cv/cv-vcf.xsl cv/brunopaulin.xml
```

Générer le pdf:

```bash
$ fop -xml cv/brunopaulin.xml -xsl cv/cv-pdf.xsl -pdf jekyll/apropos/brunopaulin.pdf
```


## Le résultat

* le [fichier pdf](/apropos/brunopaulin.pdf) avec cette [feuille de style](https://github.com/bpaulin/bpaulin.net/blob/master/cv/cv-pdf.xsl)
* la [vcard](/apropos/brunopaulin.vcf) avec cette [feuille de style](https://github.com/bpaulin/bpaulin.net/blob/master/cv/cv-vcf.xsl)
* la [page html](/apropos/) avec cette [feuille de style](https://github.com/bpaulin/bpaulin.net/blob/master/cv/cv-html.xsl)

[grunt-xsltproc]: https://npmjs.org/package/grunt-xsltproc
[XMLRésuméLibrary]: http://xmlresume.sourceforge.net/
[documentation]: http://xmlresume.sourceforge.net/user-guide/index.html
[DTD]: http://xmlresume.sourceforge.net/dtd/resume.dtd
[Europass]: http://interop.europass.cedefop.europa.eu/data-model/xml-resources/
[xmllint]: http://xmlsoft.org/xmllint.html
[libxml2-utils]: apt://libxml2-utils
[xsltproc]: http://xmlsoft.org/XSLT/xsltproc.html
[Apache FOP]: http://xmlgraphics.apache.org/fop/
