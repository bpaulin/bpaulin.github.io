---
layout:     post
title:      Tester une appli Symfony avec Behat
lang: fr
categories: programmation
---

Une procédure fonctionnelle pour configurer [Behat] et Symfony, de la création du projet aux premiers scénarios.

### Création du projet symfony

Créer un projet symfony, nommé ici _symfony-behat_

```bash 
$ curl -s https://getcomposer.org/installer | php
$ php composer.phar create-project symfony/framework-standard-edition symfony-behat 2.4.* -n
$ mv composer.phar symfony-behat/
$ cd symfony-behat/
``` 

Créer un bundle, nommé ici _Acme/BehatBundle_

```bash 
$ php app/console generate:bundle \
                  --namespace=Acme/BehatBundle \
                  --dir=src \
                  --no-interaction
``` 

### Installation de Behat, Mink & extensions

Ajouter et installer Behat, [Mink] et leurs extensions

```bash 
$ php composer.phar require --dev \
                    behat/behat:"*@stable" \
                    behat/mink:"*@stable" \
                    behat/symfony2-extension:"*@stable" \
                    behat/mink-extension:"*@stable" \
                    behat/mink-browserkit-driver:"*@stable"
``` 

### Configuration de behat

Activer les extensions en créant un fichier **behat.yml** à la racine du projet, contenant ces lignes

```yaml 
default:
    extensions:
        Behat\Symfony2Extension\Extension:
            mink_driver: true
            bundle: AcmeBehatBundle
        Behat\MinkExtension\Extension:
            default_session: 'symfony2'
``` 

Initialiser behat pour le bundle voulu

```sh 
$ ./bin/behat --init "@AcmeBehatBundle"
``` 

Remplacer dans le fichier **src/Acme/BehatBundle/Features/Context/FeatureContext.php**

```php 
<?php
// ...
class FeatureContext extends BehatContext //MinkContext if you want to test web
                  implements KernelAwareInterface
``` 

... par ...

```php 
<?php
// ...
class FeatureContext extends MinkContext 
                  implements KernelAwareInterface
``` 

### Premier test

Créer le fichier **src/Acme/BehatBundle/Features/hello.feature** contenant ces lignes
```gherkin 
Feature: L'application doit dire bonjour
  Pour utiliser behat
  En tant que dev ou client
  Je dois essayer

Scenario: La page hello world doit afficher hello world
  Given I am on "/hello/World"
   Then I should see "Hello World!"
``` 

Lancer Behat
```bash 
$ ./bin/behat 
``` 

Et savourer: l'application fonctionne comme prévu

```bash 
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
``` 

A ce stade, Mink utilise un driver très rapide mais qui ne supporte pas le javascript.

### Installation de PhantomJS

L'installation de [PhantomJS] est faite par [npm]

Créer un fichier **package.json** à la racine du projet contenant ces lignes:
json
{
    "dependencies": {
      "phantomjs": "*"
    }
}
``` 

Lancer l'installation
```bash 
$ npm install
``` 

Ajouter le driver selenium2 au dépendances
```bash 
$ php composer.phar require --dev \
                    behat/mink-selenium2-driver:"*@stable"
``` 

Modifier **behat.yml**
```yaml 
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
``` 

### Test avec PhantomJS

Ajouter un scénario avec le tag **@javascript** dans le fichier **src/Acme/BehatBundle/Features/hello.feature**
```gherkin 
@javascript
Scenario: La page hello world doit afficher hello world avec phantomjs
  Given I am on "/hello/World"
   Then I should see "Hello World!"
``` 

Lancer le serveur php
```bash 
$ php app/console server:run
``` 

Lancer PhantomJS
```bash 
$ ./node_modules/.bin/phantomjs --webdriver=8643
``` 

Et une nouvelle fois, savourez
```bash 
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
``` 

### Commandes utiles

Afficher les résultats détaillés
```bash 
$ ./bin/behat --format=pretty
``` 

Afficher les résultats sans les détails (un point par étape)
```bash 
$ ./bin/behat --format=progress
``` 

Enregistrer les résultats dans le fichier _behat.html_
```bash 
$ ./bin/behat --format=html --out=behat.html
``` 

Afficher un exemple de features
```bash 
$ ./bin/behat --story-syntax
``` 

Afficher les étapes disponibles
```bash 
$ ./bin/behat -dl
``` 

Intégration continue avec [Travis] dans le fichier**.travis.yml**:
```yaml 
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
``` 

### Liens
Le code est disponible sur [GitHub](https://github.com/bpaulin/symfony-behat) et le build sur travis: [![Build Status](https://travis-ci.org/bpaulin/symfony-behat.png?branch=master)](https://travis-ci.org/bpaulin/symfony-behat)

[Travis]: https://travis-ci.org/
[BDD]: http://en.wikipedia.org/wiki/Behavior-driven_development
[Behat]: http://behat.org/
[Mink]: http://mink.behat.org/
[Gherkin]: http://docs.behat.org/guides/1.gherkin.html
[PhantomJS]: http://phantomjs.org/
[npm]: https://npmjs.org/