---
layout:     post
title:      Behat et Symfony - 3 - Utilisation
categories: behat symfony
---
### Utilisation

Il va maintenant falloir rédiger les features dans src/Acme/DemoBundle/features/

Pour lancer les tests:
{% highlight sh %}
$ ./bin/behat "@AcmeDemoBundle"
Aucun scénario
Aucune étape
0m0.004s
{% endhighlight %}

Pour consulter un exemple de feature:
{% highlight bash %}
$ ./bin/behat "@AcmeDemoBundle" --story-syntax
{% endhighlight %}

Pour consulter les étapes définies:
{% highlight bash %}
$ ./bin/behat "@AcmeDemoBundle" -dl
{% endhighlight %}

### Premier test

*Dans l'approche BOD, le scénario est écrit **avant** de developper une fonctionnalité.*

AcmeDemoBundle permet entre autre de consulter le code d'un controlleur affichant "Hello World", ce qu'on va vérifier en créant le fichier **src/Acme/DemoBundle/Features/demo.feature**

{% highlight gherkin %}
Feature: Tester la demo de symfony
  Pour apprendre symfony
  En tant que dev
  Je veux pouvoir consulter les codes proposés

Scenario: Le code d'un HelloWorld doit être accessible
  Given I am on "/demo"
   Then I should see "Available demos"
   When I follow "Hello World"
   Then I should see "_demo_hello"
{% endhighlight %} 

La partie **Feature** explique l'interet pour l'utilisateur des scénarios de cette feature en répondant aux questions **dans quel but?** , **pour qui?** et **que doit apporter l'application?**. 

Le **Scenario** d'utilisation est le suivant:
* Si je suis sur la page demonstration (/demo)
* Alors je dois voir "Available demos" (le titre de la page)
* Quand je clique sur le lien "Hello world"
* Je dois voir le code utilisé (ici je test la presence du nom de la route, "_demo_hello")

Il ne reste plus qu'à lancer behat
{% highlight bash %}
$ ./bin/behat "@AcmeDemoBundle"
Feature: Tester la demo de symfony
  Pour apprendre symfony
  En tant que dev
  Je dois pouvoir consulter les codes proposés

  Scenario: Le code d'un HelloWorld doit être accessible # src/Acme/DemoBundle/Features/first.feature:6
    Given I am on "/demo"                                # Acme\DemoBundle\Features\Context\FeatureContext::visit()
    Then I should see "Available demos"                  # Acme\DemoBundle\Features\Context\FeatureContext::assertPageContainsText()
    When I follow "Hello World"                          # Acme\DemoBundle\Features\Context\FeatureContext::clickLink()
    Then I should see "_demo_hello"                      # Acme\DemoBundle\Features\Context\FeatureContext::assertPageContainsText()

1 scénario (1 succès)
4 étapes (4 succès)
0m0.163s
{% endhighlight %} 

### Plan de scénario
On a testé un des liens de la page demo. Il est bien sur possible de rediger 3 scenarios differents mais on peut utiliser les plans pour éviter la répetition
{% highlight gherkin %}
Feature: Tester la demo de symfony
  Pour apprendre symfony
  En tant que dev
  Je dois pouvoir consulter les codes proposés

Scenario Outline: Le code des démos doit être accessible
  Given I am on "/demo"
   Then I should see "Available demos"
   When I follow "<link>"
   Then I should see "<route>"
  Examples:
    | link                    | route       |
    | Hello World             | _demo_hello |
    | Access the secured area | _demo_login |
    | Go to the login page    | _demo_login |
{% endhighlight %} 

En spécifiant **Scenario Outline**, behat va suivre le scénario pour chaque ligne du tableau **Examples**

{% highlight bash %}
$ ./bin/behat "@AcmeDemoBundle"
Feature: Tester la demo de symfony
  Pour apprendre symfony
  En tant que dev
  Je dois pouvoir consulter les codes proposés

  Scenario Outline: Le code des démos doit être accessible # src/Acme/DemoBundle/Features/demo.feature:6
    Given I am on "/demo"                                  # Acme\DemoBundle\Features\Context\FeatureContext::visit()
    Then I should see "Available demos"                    # Acme\DemoBundle\Features\Context\FeatureContext::assertPageContainsText()
    When I follow "<link>"                                 # Acme\DemoBundle\Features\Context\FeatureContext::clickLink()
    Then I should see "<route>"                            # Acme\DemoBundle\Features\Context\FeatureContext::assertPageContainsText()

    Examples:
      | link                    | route       |
      | Hello World             | _demo_hello |
      | Access the secured area | _demo_login |
      | Go to the login page    | _demo_login |

3 scénarios (3 succès)
12 étapes (12 succès)
0m0.39s
{% endhighlight %}

### Authentification

Dans l'exemple précédent, on a pu vérifier que l'accès a la partie sécurisé redirige vers la page login

{% highlight gherkin %}
Scenario Outline: Je dois m'identifier pour consulter les pages sécurisées
  Given I am on "/demo"
    And I follow "Access the secured area"
   Then I should be on "/demo/secured/login"
   When I fill in the following:
        | Username | <login>    |
        | Password | <password> |
    And I press "Login"
   Then I should see "Hello World!"
   When I follow "Hello resource secured for admin only."
   Then I should see "<admin>"
  Examples:      
      | login | password  | admin                                |
      | user  | userpass  | access denied                        |
      | admin | adminpass | Hello World secured for Admins only! |
{% endhighlight %} 