---
layout:     post
title:      Appliquer la norme PSR-2 au code PHP
categories: programmation
---

Chaque développeur écrit son code avec ses propres habitudes d'indentation, de nommage, etc... ce qui nuit a la lisibilité du code par d'autres personens ayant d'autres habitudes.

La solution est d'adopter une norme commune. Peu importe la norme, du moment qu'elle est adoptée par tous.

### Les normes PSR

Le [PHP Framework Interop Group] publie des normes reprises par beaucoup de projets. C'est par exemple le cas des [Standards Symfony] qui suivent la norme [PSR-2].

Pas de long discours, mais un petit exemple tiré du site:
{% highlight php %}
<?php
namespace Vendor\Package;

use FooInterface;
use BarClass as Bar;
use OtherVendor\OtherPackage\BazClass;

class Foo extends Bar implements FooInterface
{
    public function sampleFunction($a, $b = null)
    {
        if ($a === $b) {
            bar();
        } elseif ($a > $b) {
            $foo->bar($arg1);
        } else {
            BazClass::bar($arg2, $arg3);
        }
    }

    final public static function bar()
    {
        // method body
    }
}
{% endhighlight %}

### Controller son code

[PHP_CodeSniffer] est disponible via composer:
{% highlight bash %}
$ php composer.phar require --dev \
                    squizlabs/php_codesniffer:"*@stable"
{% endhighlight %}

Pour valider le code d'une appli symfony contre la norme [PSR-2]:

{% highlight bash %}
$ ./bin/phpcs -p --standard=PSR2 src/
{% endhighlight %}

_Pour ajouter d'autres vérifications, notamment la présence des [DocBlocks] pour [phpDocumentor]_:

{% highlight bash %}
$ ./bin/phpcs -p src/ 
{% endhighlight %}

### Corriger son code

[php-cs-fixer] va corriger la plupart des fautes de style du code.

Pour le télécharger:

{% highlight bash %}
$ wget http://cs.sensiolabs.org/get/php-cs-fixer.phar
{% endhighlight %}

Pour mettre à jour [php-cs-fixer]:

{% highlight bash %}
$ php php-cs-fixer.phar self-update
{% endhighlight %}

Pour corriger le code d'une appli symfony pour suivre [PSR-2] plus quelques ajouts comme la suppression des _use_ inutiles par exemple:

{% highlight bash %}
$ php php-cs-fixer.phar fix src/
{% endhighlight %}

_Pour corriger le code d'une appli symfony uniquement pour [PSR-2]:_

{% highlight bash %}
$ php php-cs-fixer.phar fix src/ --level=psr2
{% endhighlight %}

[Standards Symfony]: http://symfony.com/doc/master/contributing/code/standards.html
[PSR-2]: http://www.php-fig.org/psr/psr-2/
[php-cs-fixer]: http://cs.sensiolabs.org/
[PHP_CodeSniffer]: https://github.com/squizlabs/PHP_CodeSniffer
[PHP Framework Interop Group]: http://www.php-fig.org/
[phpDocumentor]: http://www.phpdoc.org/
[DocBlocks]: http://www.phpdoc.org/docs/latest/guides/docblocks.html