---
layout:     post
title:      Utiliser FlexGet pour télécharger automatiquement les .torrents
categories: réseau linux torrent
---

# Les outils

[FlexGet](http://flexget.com/) est utilisé pour traiter le fil rss gracieusement fourni par [showrss](http://showrss.karmorra.info/). Le premier est téléchargeable librement, le deuxième ne demande que l'ouverture d'un "compte" gratuit

# L'installation

easy_install est nécessaire. Au cas ou, pour l'installer:

    sudo apt-get install python-setuptools

Maintenant, l'instal de flexget

    sudo easy_install flexget

Création du dossier où sera enregistré la config de flexget

    mkdir ~/.flexget


# La configuration

Pour éditer la config de flexget

    nano .flexget/config.yml

Une config de base, sans fioriture (utilisée chez moi). Pas de téléchargement 720p, juste HDTV.
La syntaxe du fichier de config est au format [YAML](http://fr.wikipedia.org/wiki/YAML)

    feeds:
      showrss:
        rss: http://showrss.karmorra.info/rss.php?user_id=#####&hd=null&proper=null
        accept_all: yes
        download: /home/medias/share/downloads/watch/

Le dossier download est le watch-dir de transmission, pour que les torrents soient téléchargés immédiatement.
L'option rss renvoie vers l'url du fil rss fourni par showrss.

# Le lancement


    flexget

ou

    /usr/local/bin/flexget


# La planification

Pour ajouter une tache

    crontab -e

Ajouter a la fin du texte la ligne

    @hourly /usr/local/bin/flexget --cron

Flexget s’exécute maintenant toutes les heures. Pour surveiller ça en affichant les 10 dernières lignes du log:

    tail -f flexget.log
