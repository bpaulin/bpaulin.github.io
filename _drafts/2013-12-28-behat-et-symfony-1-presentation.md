---
layout:     post
title:      Tester une appli Symfony avec Behat, Présentation
categories: behat symfony test
---

Behat est un outil de [BDD]: Le principe est de **valider les fonctionnalitées de l'application** et non le code. Le BDD cible l'utilisateur de l'appli: ce qu'il veut faire, ce qu'il doit faire, ce qu'il doit obtenir.

[Behat] est utilisé avec [Mink], un framework de test pour les applications web.

[BDD]: http://en.wikipedia.org/wiki/Behavior-driven_development
[Behat]: http://behat.org/
[Mink]: http://mink.behat.org/

### Scénarios

L'utilisation de chaque fonction de l'appli (**Feature**) est décrite sous forme de scénarios d'utilisation (**Scenario**).

Les scénarios utilisent [Gherkin], une syntaxe extremement claire et lisible. 
Ils peuvent (doivent) être **compréhensibles par l'utilisateur ou le client** et non uniquement par le developpeur.
Ils sont rédigés sans utiliser de termes techniques et sans avoir besoin de comprendre ou connaitre le fonctionnement interne de l'appli.
Si besoin, **tout peut être en français**.

Un exemple:
{% highlight gherkin %}
Feature: L'application doit dire bonjour
  Pour utiliser behat
  En tant que dev ou client
  Je dois essayer

Scenario: La page hello world doit afficher hello world
  Given I am on "/hello/World"
   Then I should see "Hello World!"
{% endhighlight %}

La partie **Feature** explique l'interet pour l'utilisateur des scénarios de cette feature en répondant aux questions 
* **Dans quel but?**
* **Pour qui?**
* **Que doit apporter l'application?**

Le **Scenario** d'utilisation est ici la succession des étapes suivantes:
1. Si je suis sur la page /hello/World
2. Alors je dois voir "Hello World!""

[Gherkin]: http://docs.behat.org/guides/1.gherkin.html

### Avantages

* Ecrire un scénario permet de s'éloigner de la mécanique interne du projet et d'apprehender l'application avec le regard de l'utilisateur final.
* Une fois le scénario écrit, le dev sait exactement le résultat qu'il doit atteindre et ne perd pas de temps avec des fonctions inutiles ou non voulues.
* Le scénario offre un jalon écrit: le client a demandé telle fonction à telle date et le dev l'a implementé à telle date.
* Le scénario étant intégré aux sources de l'appli, il est très facile de verifier que tout les scénarios sont toujours appliqués après avoir rajouté une nouvelle fonctionnalitée.

Pour en savoir plus, une excellent intro chez [soat.fr](http://blog.soat.fr/2011/06/introduction-au-behavior-driven-development/)