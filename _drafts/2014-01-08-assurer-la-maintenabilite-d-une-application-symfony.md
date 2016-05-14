---
layout:     post
title:      Assurer la maintenabilité d'une application symfony
lang: fr
categories: programmation
---

Une procédure fonctionnelle pour pouvoir vérifier la [Maintenabilité] d'une application symfony en une seule commande.
Les outils utilisés:

- [PHP_CodeSniffer] pour vérifier l'application d'une convention de nommage
- [PHPMD] pour vérifier la clarté du code
- [phpcpd] pour vérifier l'absence de lignes copiées\collées
- [Phing] pour lier le tout

### Installation

Tout s'installe via composer:

```bash
$ php composer.phar require --dev \
                    squizlabs/php_codesniffer:"*@stable" \
                    phpmd/phpmd:"*@stable" \
                    sebastian/phpcpd:"*@stable" \
                    phing/phing:"*@stable"
```

### Configuration

Pour [PHPMD], créer le fichier **app/phpmd_rules.xml** contenant:

```xml
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
```

Pour [Phing], créer le fichier **maintainability.xml** à la racine projet contenant:

```xml
<?xml version="1.0"?>
<project name="Maintainability" default="maintainability" basedir='.'>
    <target name="maintainability"
        depends="phpcs, phpmd, phpcpd">
    </target>
    <target name="phpcs">
        <exec executable="./bin/phpcs" passthru="true" checkreturn="true">
            <arg value="-p"/>
            <arg value="--standard=PSR2"/>
            <arg path="src/"/>
        </exec>
    </target>
    <target name="phpmd">
        <exec executable="./bin/phpmd" passthru="true" checkreturn="true">
            <arg path="src/"/>
            <arg value="text"/>
            <arg value="app/phpmd_rules.xml"/>
        </exec>
    </target>
    <target name="phpcpd">
        <exec executable="./bin/phpcpd" passthru="true" checkreturn="true">
            <arg value="--progress"/>
            <arg line="--names *.php,*.twig"/>
            <arg path="src/"/>
        </exec>
    </target>
</project>

```

### Utilisation

Pour vérifier que le code est propre:
```bash
$ ./bin/phing -f maintainability.xml
```

Intégration continue avec [Travis] dans le fichier**.travis.yml**:
```yml
language: php

php:
  - 5.3.3
  - 5.3
  - 5.4

before_script: composer install -n

script: ./bin/phing -f maintainability.xml
```

Si aucune erreur n'est levée, le code est propre ... mais rien ne dit que l'application fonctionne, ce n'est pas le but ici.

### Résultat

A titre d'exemple, les analyses du bundle AcmeDemo:

#### phpcs

```bash
$ ./bin/phing phpcs -f maintainability.xml
Buildfile: /home/bruno/Dev/bpaulin/symfony-maintainability/maintainability.xml

Maintainability > phpcs:

........E.W


FILE: ...mfony-maintainability/src/Acme/DemoBundle/Command/HelloWorldCommand.php
--------------------------------------------------------------------------------
FOUND 1 ERROR(S) AFFECTING 1 LINE(S)
--------------------------------------------------------------------------------
 29 | ERROR | Opening parenthesis of a multi-line function call must be the
    |       | last content on the line
--------------------------------------------------------------------------------


FILE: ...ny-maintainability/src/Acme/DemoBundle/Twig/Extension/DemoExtension.php
--------------------------------------------------------------------------------
FOUND 0 ERROR(S) AND 2 WARNING(S) AFFECTING 2 LINE(S)
--------------------------------------------------------------------------------
 36 | WARNING | Line exceeds 120 characters; contains 147 characters
 64 | WARNING | Line exceeds 120 characters; contains 146 characters
--------------------------------------------------------------------------------

Time: 0 seconds, Memory: 3.75Mb

Execution of target "phpcs" failed for the following reason: Task exited with code 1

BUILD FAILED
Task exited with code 1
Total time: 0.2553 seconds
```

#### phpmd

```bash
$ ./bin/phing phpmd -f maintainability.xml
Buildfile: /home/bruno/Dev/bpaulin/symfony-maintainability/maintainability.xml

Maintainability > phpmd:


/home/bruno/Dev/bpaulin/symfony-maintainability/src/Acme/DemoBundle/Controller/DemoController.php:44    Avoid unused local variables such as '$mailer'.
/home/bruno/Dev/bpaulin/symfony-maintainability/src/Acme/DemoBundle/DependencyInjection/AcmeDemoExtension.php:12    Avoid unused parameters such as '$configs'.
/home/bruno/Dev/bpaulin/symfony-maintainability/src/Acme/DemoBundle/Form/ContactType.php:10 Avoid unused parameters such as '$options'.
/home/bruno/Dev/bpaulin/symfony-maintainability/src/Acme/DemoBundle/Twig/Extension/DemoExtension.php:59Avoid variables with short names like $r. Configured minimum length is 2.
/home/bruno/Dev/bpaulin/symfony-maintainability/src/Acme/DemoBundle/Twig/Extension/DemoExtension.php:60Avoid variables with short names like $m. Configured minimum length is 2.
Execution of target "phpmd" failed for the following reason: Task exited with code 2

BUILD FAILED
Task exited with code 2
Total time: 0.3151 seconds
```

#### phpcpd

```bash
$ ./bin/phing phpcpd -f maintainability.xml
Buildfile: /home/bruno/Dev/bpaulin/symfony-maintainability/maintainability.xml

Maintainability > phpcpd:

phpcpd 2.0.0 by Sebastian Bergmann.

 19/19 [============================] 100%

0.00% duplicated lines out of 612 total lines of code.

Time: 33 ms, Memory: 3.00Mb

BUILD FINISHED

Total time: 0.1066 seconds
```

### Liens
Le code est disponible sur [GitHub](https://github.com/bpaulin/symfony-maintenability) et le build sur travis: [![Build Status](https://travis-ci.org/bpaulin/symfony-maintenability.png?branch=master)](https://travis-ci.org/bpaulin/symfony-maintenability)

[Travis]: https://travis-ci.org/
[Maintenabilité]: http://fr.wikipedia.org/wiki/Maintenabilit%C3%A9
[PHPMD]: http://phpmd.org/
[phpcpd]: https://github.com/sebastianbergmann/phpcpd
[PHP_CodeSniffer]: https://github.com/squizlabs/PHP_CodeSniffer
[Phing]: http://www.phing.info
