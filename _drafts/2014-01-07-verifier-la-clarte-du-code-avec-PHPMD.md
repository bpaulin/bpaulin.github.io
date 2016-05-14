---
layout:     post
title:      Vérifier la clarté du code avec PHPMD
lang: fr
categories: programmation
---

[PHP Mess Detector (PHPMD)][PHPMD] est littéralement un détecteur de bordel. Il analyse le code PHP pour détecter des _problèmes_ nuisant à la [Maintenabilité] d'une application, comme par exemple des variables ou méthodes déclarées mais pas utilisées, un nommage trop long ou trop court, les méthodes trop longues ou trop complexes, etc...

### Installation

[PHPMD] est disponible via composer:

{% highlight bash %}
$ php composer.phar require --dev \
                    phpmd/phpmd:"*@stable"
{% endhighlight %}

### Utilisation

[PHPMD] demande 3 arguments:
* les dossiers (ou fichiers) à analyser, séparés par des virgules
* le type de sortie voulu (**xml**, **text** ou **html**)
* les règles à suivre (**cleancode**, **codesize**, **controversial**, **design**, **naming**, **unusedcode**), séparées par des virgules

Par exemple, pour vérifier le nommage et la longueur des méthodes d'une appli symfony et afficher le résultat dans le terminal:

{% highlight bash %}
$ ./bin/phpmd src/ text codesize,naming
{% endhighlight %}

Il est possible de définir dans un fichier xml l'ensemble des règles à appliquer et même de surcharger certaines vérifications.

Pour exemple, j'utilise ce fichier **app/phpmd_rules.xml** pour mes symfony. Il applique toutes les règles, fixe la longueur minimal des noms de variables à 2 caractères (pour signaler **$i** mais laisser passer le fameux **$em**) et fixe la taille maximale d'une classe à 20 méthodes.

{% highlight xml %}
<?xml version="1.0"?>
<ruleset name="Bpaulin phpmd ruleset"
         xmlns="http://pmd.sf.net/ruleset/1.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://pmd.sf.net/ruleset/1.0.0 http://pmd.sf.net/ruleset_xml_schema.xsd"
         xsi:noNamespaceSchemaLocation=" http://pmd.sf.net/ruleset_xml_schema.xsd">
    <description> phpmd ruleset for bpaulin</description>
    <rule ref="rulesets/unusedcode.xml" />
    <rule ref="rulesets/naming.xml" >
        <exclude name="ShortVariable" />
    </rule>
    <rule ref="rulesets/naming.xml/ShortVariable">
        <properties>
            <property name="minimum" value="2" />
        </properties>
    </rule>
    <rule ref="rulesets/design.xml" />
    <rule ref="rulesets/controversial.xml" />
    <rule ref="rulesets/codesize.xml" >
        <exclude name="TooManyMethods" />
    </rule>
    <rule ref="rulesets/codesize.xml/TooManyMethods">
        <properties>
            <property name="maxmethods" value="20" />
        </properties>
    </rule>
</ruleset>
{% endhighlight %}

Avec ce fichier, la vérification devient:

{% highlight bash %}
$ ./bin/phpmd src/ text app/phpmd_rules.xml
{% endhighlight %}

[PHPMD]: http://phpmd.org/
[Maintenabilité]: http://fr.wikipedia.org/wiki/Maintenabilit%C3%A9
