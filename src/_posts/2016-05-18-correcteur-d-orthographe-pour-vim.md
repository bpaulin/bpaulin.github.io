---
title: Correcteur d'orthographe pour Vim
date: 2016-05-18
summary: ' '
---

Vim est bien, Vim est grand. C'est plus rapide d'apprendre à s'en servir que d'apprendre à s'en passer.

J'écris ce site quasiment qu'avec Vim et j'ai donc besoin d'un correcteur d'orthographe. Rien à faire, rien à installer: c'est déjà prévu.

## Comment lancer et arrêter la correction

Commencer la vérification de l'orthographe avec

```
:set spell
```

Ou pour une autre langue

```
:set spell spelllang=fr
```
(Si c'est la première fois pour ce langage, Vim va télécharger les fichiers dont il a besoin)

Arrêter la vérification

```
:set nospell
```

## Comment utiliser la correction

 * **]s** aller à l'erreur suivante
 * **[s** aller à l'erreur précédente
 * **z=** suggérer des correction
 * **zg** ajouter le mot au dictionnaire
 * **zug** annuler l'ajout au dictionnaire

## Lancer automatiquement la correction

Pour corriger automatiquement les fichiers markdown (.md), ajouter cette ligne à votre ~/.vimrc

```
autocmd BufEnter *.md set spell
```
