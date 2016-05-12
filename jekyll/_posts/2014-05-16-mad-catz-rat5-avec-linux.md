---
layout:     post
title:      Souris Mad Catz R.A.T.5 sous linux
lang: fr
categories: linux
---

## Le problème

J’ai changé ma souris pour une mad catz RAT5. Elle réagit bizarrement avec mon poste (focus de la souris différent du focus ‘officiel’, impossibilité de passer un lecteur falsh en plein écran, etc).
Ces bugs surviennent quel que soit le bureau utilisé (cinnamon, xfce, gnome3 ou openbox).

## La solution

Cette souris demande une déclaration spéciale au serveur X. J’ai commencé par modifier directement xorg.conf, mais je devais refaire l’opération après chaque mise à jour.
Actuellement, ce qui marche chez moi est de créer le fichier **/etc/X11/xorg.conf.d/rat5.conf** contenant:

{% highlight bash %}
Section "InputClass"
    Identifier "Mad Catz R.A.T. 5"
    MatchProduct "Mad Catz Mad Catz R.A.T.5 Mouse"
    MatchDevicePath "/dev/input/event*"
    Option "Buttons" "21"
    Option "ButtonMapping" "1 2 3 4 5 0 0 11 10 7 6 8 0 0 0 0"
    Option "ZAxisMapping" "4 5 11 10"
    Option "AutoReleaseButtons" "13 14 15"
EndSection
{% endhighlight %}

Après redemarrage, tout fonctionne...
