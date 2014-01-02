---
layout:     post
title:      Ubuntu server 11.10 - Partie 1
categories: linux
---
Les manipulations se font sur une instal fraîche, sans les mises a jour automatique et en ayant sélectionné openssh et lamp lors de l'installation

# Mise a jour

Deja, autant avoir un sources.list bien propre donc pour sauvegarder l'ancien:


    sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak

et pour éditer le nouveau:


    sudo nano /etc/apt/sources.list

Avec comme contenu (exactement les mêmes dépôts, mais présentés plus clairement)

    #############################################################
    ################### OFFICIAL UBUNTU REPOS ###################
    #############################################################

    ###### Ubuntu Main Repos
    deb http://fr.archive.ubuntu.com/ubuntu/ oneiric main restricted universe multiverse

    ###### Ubuntu Update Repos
    deb http://fr.archive.ubuntu.com/ubuntu/ oneiric-security main restricted universe multiverse
    deb http://fr.archive.ubuntu.com/ubuntu/ oneiric-updates main restricted universe multiverse
    deb http://fr.archive.ubuntu.com/ubuntu/ oneiric-backports main restricted universe multiverse

Les dépots sont prêts, place à la mise a jour


    sudo apt-get update && sudo apt-get dist-upgrade

# Utilisateurs

En plus de moi, il y aura madame


    sudo adduser maud

et un utilisateur juste là pour gérer les bibliothèques


    sudo adduser medias

# openssh-server

si le serveur ssh n'a pas été installé avec le système, cette commande le fera


    sudo apt-get install openssh-server

**ATTENTION: EVITER DE FAIRE CES MANIPS SI VOUS N'AVEZ QU'UN ACCES SSH**
Un peu de sécurisation maintenant. Le fichier à modifier est /etc/ssh/sshd_config


    nano /etc/ssh/sshd_config

On change juste le port utilisé par ssh et on restreint l’accès a un seul groupe

    Port 2092
    AllowGroups ssh_users

Pour ubuntu server, les autres options sont déja bien d'origine. Reste donc juste a relancer ssh pour prendre en compte les modifs


    sudo service ssh restart

On crée le groupe autorisé à se connecter via SSH


    sudo groupadd -g 1100 ssh_users

et on ajoute le ou les utilisateurs à ce groupe


    sudo usermod -a -G ssh_users bruno

Pour vérifier si tout va bien, on se connecte depuis une autre machine


    ssh -p 2902 bruno@192.168.1.2

# UFW

Pour finir cette partie, on met en place un pare-feu basique. Encore une fois, ufw est censé être déjà installé. Si ce n'est pas le cas:

    sudo apt-get install ufw
On l'active, on bloque tout le trafic entrant et on laisse passer les connections ssh, en fonction du port utilisé dans sshd_config

    sudo ufw enable
sudo ufw default deny
sudo ufw allow 2092/tcpPour prendre en compte les changements, on redémarre

    sudo service ufw restart
A nouveau, depuis une machine distante, on vérifie la connexion

    ssh -p 2902 bruno@192.168.1.2
Si tout va bien, plus aucun contact 'physique' ne sera nécessaire pour ce serveur, on peut le ranger au fond de son local