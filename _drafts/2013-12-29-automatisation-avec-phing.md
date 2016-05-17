---
layout:     post
title:      Automatisation avec phing
lang: fr
categories: programmation
---

Ajouter [Phing] au dépendances de [Composer]

```bash 
$ php composer.phar require --dev \
                    phing/phing:"*@stable"
``` 

Créer à la racine du projet le fichier **build.xml** contenant par exemple pour tester une appli symfony
```xml 
<?xml version="1.0"?>
<project name="Example" default="test" basedir='.'>
    <target name="test"
        depends="test:phpunit, test:behat">
    </target>
    <target name="test:phpunit">
        <exec command="./bin/phpunit -c app" 
            passthru="true" 
            checkreturn="true"/>
    </target>
    <target name="test:behat">
        <exec command="./bin/behat --format=progress" 
            passthru="true" 
            checkreturn="true"/>
    </target>
</project>
``` 

Avec ce build, pour lancer les test unitaires & de comportement:

```bash 
$ ./bin/phing test
``` 

[Phing]: http://www.phing.info/
[Composer]: http://getcomposer.org/