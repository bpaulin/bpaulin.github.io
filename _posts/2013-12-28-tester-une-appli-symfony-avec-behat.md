---
layout:     post
title:      Tester une appli Symfony avec Behat
categories: behat symfony travis
---

Une procédure fonctionnelle pour configurer [Behat] et Symfony, de la création du projet aux premiers scénarios.

### Création du projet symfony

Créer un projet symfony, nommé ici _symfony-behat_
{% highlight bash %}
$ curl -s https://getcomposer.org/installer | php
$ php composer.phar create-project symfony/framework-standard-edition symfony-behat 2.4.* -n
$ mv composer.phar symfony-behat/
$ cd symfony-behat/
{% endhighlight %}

Créer un bundle, nommé ici _Acme/BehatBundle_

{% highlight bash %}
$ php app/console generate:bundle \
                  --namespace=Acme/BehatBundle \
                  --dir=src \
                  --no-interaction
{% endhighlight %}

### Installation de Behat, Mink & extensions

Ajouter et installer Behat, [Mink] et leurs extensions

{% highlight bash %}
$ php composer.phar require --dev \
                    behat/behat:"*@stable" \
                    behat/mink:"*@stable" \
                    behat/symfony2-extension:"*@stable" \
                    behat/mink-extension:"*@stable" \
                    behat/mink-browserkit-driver:"*@stable"
{% endhighlight %}

### Configuration de behat

Activer les extensions en créant un fichier **behat.yml** à la racine du projet, contenant ces lignes

{% highlight yaml %}
default:
    extensions:
        Behat\Symfony2Extension\Extension:
            mink_driver: true
            bundle: AcmeBehatBundle
        Behat\MinkExtension\Extension:
            default_session: 'symfony2'
{% endhighlight %}

Initialiser behat pour le bundle voulu

{% highlight sh %}
$ ./bin/behat --init "@AcmeBehatBundle"
{% endhighlight %}

Remplacer dans le fichier **src/Acme/BehatBundle/Features/Context/FeatureContext.php**

{% highlight php %}
<?php
// ...
class FeatureContext extends BehatContext //MinkContext if you want to test web
                  implements KernelAwareInterface
{% endhighlight %}

... par ...

{% highlight php %}
<?php
// ...
class FeatureContext extends MinkContext 
                  implements KernelAwareInterface
{% endhighlight %}

### Premier test

Créer le fichier **src/Acme/BehatBundle/Features/hello.feature** contenant ces lignes
{% highlight gherkin %}
Feature: L'application doit dire bonjour
  Pour utiliser behat
  En tant que dev ou client
  Je dois essayer

Scenario: La page hello world doit afficher hello world
  Given I am on "/hello/World"
   Then I should see "Hello World!"
{% endhighlight %}

Lancer Behat
{% highlight bash %}
$ ./bin/behat 
{% endhighlight %}

Et savourer: l'application fonctionne comme prévu

{% highlight bash %}
Feature: L'application doit dire bonjour
  Pour utiliser behat
  En tant que dev ou client
  Je dois essayer

  Scenario: La page hello world doit afficher hello world # src/Acme/BehatBundle/Features/hello.feature:6
    Given I am on "/hello/World"                          # Acme\BehatBundle\Features\Context\FeatureContext::visit()
    Then I should see "Hello World!"                      # Acme\BehatBundle\Features\Context\FeatureContext::assertPageContainsText()

1 scénario (1 succès)
2 étapes (2 succès)
0m0.165s
{% endhighlight %}

A ce stade, Mink utilise un driver très rapide mais qui ne supporte pas le javascript.

### Installation de PhantomJS

L'installation de [PhantomJS] est faite par [npm]

Créer un fichier **package.json** à la racine du projet contenant ces lignes:
{% highlight json%}
{
    "dependencies": {
      "phantomjs": "*"
    }
}
{% endhighlight %}

Lancer l'installation
{% highlight bash %}
$ npm install
{% endhighlight %}

Ajouter le driver selenium2 au dépendances
{% highlight bash %}
$ php composer.phar require --dev \
                    behat/mink-selenium2-driver:"*@stable"
{% endhighlight %}

Modifier **behat.yml**
{% highlight yaml %}
default:
    extensions:
        Behat\Symfony2Extension\Extension:
            mink_driver: true
            bundle: AcmeBehatBundle
        Behat\MinkExtension\Extension:
            default_session: 'symfony2'
            base_url: 'http://localhost:8000'
            selenium2:
                wd_host: "http://localhost:8643/wd/hub"
{% endhighlight %}

### Test avec PhantomJS

Ajouter un scénario avec le tag **@javascript** dans le fichier **src/Acme/BehatBundle/Features/hello.feature**
{% highlight gherkin %}
@javascript
Scenario: La page hello world doit afficher hello world avec phantomjs
  Given I am on "/hello/World"
   Then I should see "Hello World!"
{% endhighlight %}

Lancer le serveur php
{% highlight bash %}
$ php app/console server:run
{% endhighlight %}

Lancer PhantomJS
{% highlight bash %}
$ ./node_modules/.bin/phantomjs --webdriver=8643
{% endhighlight %}

Et une nouvelle fois, savourez
{% highlight bash %}
$ ./bin/behat
Feature: L'application doit dire bonjour
  Pour utiliser behat
  En tant que dev ou client
  Je dois essayer

  Scenario: La page hello world doit afficher hello world # src/Acme/BehatBundle/Features/hello.feature:6
    Given I am on "/hello/World"                          # Acme\BehatBundle\Features\Context\FeatureContext::visit()
    Then I should see "Hello World!"                      # Acme\BehatBundle\Features\Context\FeatureContext::assertPageContainsText()

  @javascript
  Scenario: La page hello world doit afficher hello world avec phantomjs # src/Acme/BehatBundle/Features/hello.feature:11
    Given I am on "/hello/World"                                         # Acme\BehatBundle\Features\Context\FeatureContext::visit()
    Then I should see "Hello World!"                                     # Acme\BehatBundle\Features\Context\FeatureContext::assertPageContainsText()

2 scénarios (2 succès)
4 étapes (4 succès)
0m0.267s
{% endhighlight %}

### Commandes utiles

Afficher les résultats détaillés
{% highlight bash %}
$ ./bin/behat --format=pretty
{% endhighlight %}

Afficher les résultats sans les détails (un point par étape)
{% highlight bash %}
$ ./bin/behat --format=progress
{% endhighlight %}

Enregistrer les résultats dans le fichier _behat.html_
{% highlight bash %}
$ ./bin/behat --format=html --out=behat.html
{% endhighlight %}

Afficher un exemple de features
{% highlight bash %}
$ ./bin/behat --story-syntax
{% endhighlight %}

Afficher les étapes disponibles
{% highlight bash %}
$ ./bin/behat -dl
{% endhighlight %}

Intégration continue avec [Travis] dans le fichier**.travis.yml**:
{% highlight yaml %}
language: php

php:
    - 5.4

before_script: 
    - composer install -n
    - npm install
    - php app/console server:run &
    - ./node_modules/.bin/phantomjs --webdriver=8643 &

script: 
    - ./bin/behat --format=progress
{% endhighlight %}

### Liens
Le code est disponible sur [GitHub](https://github.com/bpaulin/symfony-behat) et le build sur travis: [![Build Status](https://travis-ci.org/bpaulin/symfony-behat.png?branch=master)](https://travis-ci.org/bpaulin/symfony-behat)

[Travis]: https://travis-ci.org/
[BDD]: http://en.wikipedia.org/wiki/Behavior-driven_development
[Behat]: http://behat.org/
[Mink]: http://mink.behat.org/
[Gherkin]: http://docs.behat.org/guides/1.gherkin.html
[PhantomJS]: http://phantomjs.org/
[npm]: https://npmjs.org/