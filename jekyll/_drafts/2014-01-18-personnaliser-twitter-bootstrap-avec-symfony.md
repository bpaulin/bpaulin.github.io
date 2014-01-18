---
layout:     post
title:      Personnaliser Twitter Bootstrap avec Assetic pour Symfony
categories: Programmation
---

[Twitter bootstrap][TwBs] est un framework front-end extremement bien fait. Il permet en très peu de temps de transformer un site moche et noir sur blanc (ce qui était jusqu'a la découverte de bootstrap ma _patte graphique_) en un site responsive ressemblant à quelque chose de propre. La méthode est simpliste: ajouter quelques classes aux éléments html, appeler les css et javascripts d'un [CDN] et c'est tout, inutile d'écrire la moindre ligne de css.

Si on veut aller plus loin, il est possible de personnaliser l'apparence en modifiant les fichier [variables.less] qui contient toutes les déclarations de couleurs, de tailles, les border-radius etc. Ce fichier peut être modifié directement et le site officiel permet de saisir les variables (sur [cette page][Customize])pour télécharger une version personnalisée des css. Plus visuel, [Bootstrap-magic] permet d'importer un ancien **variables.less**, de voir directement les modifications et de télécharger la nouvelle version.

## Versionner son bootstrap pour une appli symfony

* Ajouter uniquement les css personnalisée à un projet symfony pose un problème: sans sauvegarde du fichier variables.less, modifier **une** variable impose de redéfinir l'ensemble.
* Ajouter l'ensemble des *.less a son projet compliquer la mise à jour vers une nouvelle version de bootstrap.

Dans ces deux cas, l'opération sera de toute façon manuelle... inacceptable

Avec la procédure qui suit, bootstrap est une dépendance du projet (donc facilement et automatiquement mis à jour) et on versionne uniquement variables.less (donc la personnalisation est modifiable facilement)

## Création du projet symfony

Créer un projet symfony, nommé ici _symfony-twbs_

{% highlight bash %}
$ curl -s https://getcomposer.org/installer | php
$ php composer.phar create-project symfony/framework-standard-edition symfony-twbs 2.4.* -n
$ mv composer.phar symfony-twbs/
$ cd symfony-twbs/
{% endhighlight %}

Créer un bundle, nommé ici _Acme/TwbsBundle_

{% highlight bash %}
$ php app/console generate:bundle \
                  --namespace=Acme/TwbsBundle \
                  --dir=src \
                  --no-interaction
{% endhighlight %}

## Ajout de twitter bootstrap aux dépendances

Pour rester dans le style symfony, ajouter bootstrap aux dépendances de composer:
{% highlight bash %}
$ php composer.phar require --dev \
                    twbs/bootstrap:"3.0.*" 
{% endhighlight %}

## Installation des outils

less (pour transformer les fichiers *.less en *.css) s'installe via npm. L'installation doit etre globale pour qu'assetic et symfony puissent l'utiliser.
{% highlight bash %}
$ sudo npm install -g less
{% endhighlight %}

## Configuration

A ce stade, les sources de bootstrap sont dans les dossiers **js/** et **less/** dans **vendor/twbs/bootstrap/**.

Il faut maintenant copier **bootstrap.less** (le fichier _principal_, celui qui importe les autres) et **variables.less** dans les sources du bundle

{% highlight bash %}
$ mkdir -p src/Acme/TwbsBundle/Resources/public/less
$ cp vendor/twbs/bootstrap/less/variables.less src/Acme/TwbsBundle/Resources/public/less/
$ cp vendor/twbs/bootstrap/less/bootstrap.less src/Acme/TwbsBundle/Resources/public/less/
{% endhighlight %}

Modifier **src/Acme/TwbsBundle/Resources/public/less/bootstrap.less** pour modifer tout les chemins, sauf celui de variables.less, en les préfixant par **../../../../../../vendor/twbs/bootstrap/less/**

{% highlight css %}
// Core variables and mixins
@import "variables.less";
@import "../../../../../../vendor/twbs/bootstrap/less/mixins.less";

// Reset
@import "../../../../../../vendor/twbs/bootstrap/less/normalize.less";
@import "../../../../../../vendor/twbs/bootstrap/less/print.less";

// Core CSS
@import "../../../../../../vendor/twbs/bootstrap/less/scaffolding.less";
@import "../../../../../../vendor/twbs/bootstrap/less/type.less";
@import "../../../../../../vendor/twbs/bootstrap/less/code.less";
@import "../../../../../../vendor/twbs/bootstrap/less/grid.less";
@import "../../../../../../vendor/twbs/bootstrap/less/tables.less";
@import "../../../../../../vendor/twbs/bootstrap/less/forms.less";
@import "../../../../../../vendor/twbs/bootstrap/less/buttons.less";

// Components
@import "../../../../../../vendor/twbs/bootstrap/less/component-animations.less";
@import "../../../../../../vendor/twbs/bootstrap/less/glyphicons.less";
@import "../../../../../../vendor/twbs/bootstrap/less/dropdowns.less";
@import "../../../../../../vendor/twbs/bootstrap/less/button-groups.less";
@import "../../../../../../vendor/twbs/bootstrap/less/input-groups.less";
@import "../../../../../../vendor/twbs/bootstrap/less/navs.less";
@import "../../../../../../vendor/twbs/bootstrap/less/navbar.less";
@import "../../../../../../vendor/twbs/bootstrap/less/breadcrumbs.less";
@import "../../../../../../vendor/twbs/bootstrap/less/pagination.less";
@import "../../../../../../vendor/twbs/bootstrap/less/pager.less";
@import "../../../../../../vendor/twbs/bootstrap/less/labels.less";
@import "../../../../../../vendor/twbs/bootstrap/less/badges.less";
@import "../../../../../../vendor/twbs/bootstrap/less/jumbotron.less";
@import "../../../../../../vendor/twbs/bootstrap/less/thumbnails.less";
@import "../../../../../../vendor/twbs/bootstrap/less/alerts.less";
@import "../../../../../../vendor/twbs/bootstrap/less/progress-bars.less";
@import "../../../../../../vendor/twbs/bootstrap/less/media.less";
@import "../../../../../../vendor/twbs/bootstrap/less/list-group.less";
@import "../../../../../../vendor/twbs/bootstrap/less/panels.less";
@import "../../../../../../vendor/twbs/bootstrap/less/wells.less";
@import "../../../../../../vendor/twbs/bootstrap/less/close.less";

// Components w/ JavaScript
@import "../../../../../../vendor/twbs/bootstrap/less/modals.less";
@import "../../../../../../vendor/twbs/bootstrap/less/tooltip.less";
@import "../../../../../../vendor/twbs/bootstrap/less/popovers.less";
@import "../../../../../../vendor/twbs/bootstrap/less/carousel.less";

// Utility classes
@import "../../../../../../vendor/twbs/bootstrap/less/utilities.less";
@import "../../../../../../vendor/twbs/bootstrap/less/responsive-utilities.less";
{% endhighlight %}

## Configuration d'assetic
Pour garder la configuration propre, créer le fichier **app/config/assetic.yml** contenant ces lignes:

[TwBs]: http://getbootstrap.com/
[CDN]: http://www.bootstrapcdn.com/
[Customize]: http://getbootstrap.com/customize/
[Bootstrap-magic]: http://pikock.github.io/bootstrap-magic/
[variables.less]: https://github.com/twbs/bootstrap/blob/master/less/variables.less