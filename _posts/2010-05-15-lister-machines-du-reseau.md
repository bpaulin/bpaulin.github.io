---
layout:     post
title:      Lister les machines sur son réseau
---

Quand on ne sait plus quelle ip a été attribuée à une machine, le paquet nmap peut être utile. Il n’était pas installé par défaut sur mon ubuntu. Pour l'installer, taper dans un terminal cette commande:
{% highlight sh %}
$ sudo apt-get install nmap
{% endhighlight %}
Dans mon cas, je ne l'utilise que d'une seule façon:

{% highlight sh %}
$ nmap -sP 192.168.1.0/24
Starting Nmap 5.00 ( http://nmap.org ) at 2010-05-15 17:48 CEST
Host ######.home (192.168.1.xx) is up (0.00095s latency).
Host 192.168.1.xx is up (0.00024s latency).
Host #####.home (192.168.1.xx) is up (0.0018s latency).
Host #####.home (192.168.1.xx) is up (0.000049s latency).
Host 192.168.1.xxx is up (0.0026s latency).
Nmap done: 256 IP addresses (5 hosts up) scanned in 3.48 seconds
{% endhighlight %}
* *-sP:* ne fait que 'pinguer' la série d'ip, et retient celles qui répondent
* *192.168.1.0/24:* la plage d'adresse à tester(/24 inclut toutes les adresses dont les 3 premiers chiffres correspondent donc ici de 192.168.1.0 à 192.168.1.255)

Le [site officiel](http://nmap.org/), et la [page de manuel](http://nmap.org/book/man.html), qui existe aussi en [français](http://nmap.org/man/fr/)