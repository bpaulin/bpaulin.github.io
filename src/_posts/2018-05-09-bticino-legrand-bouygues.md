---
title: Config de myhomeserver1
date: 2018-05-09
summary: ' '
---

# Domotique, partie 1

Nous avons emmenagé recemment dans un appartement équipé d'une passerelle bticino controllant les lumieres et les stores (techniquement, tout ce que nos interrupteurs controllent).
De base, rien n'etait fourni/expliqué pour se lancer dans la domotique d'ou ce tuto (coucou aux membres du groupe facebook de notre immeuble qui decouvrent qu'ils sont voisins avec un geek. promis je ne mords pas).

## But final
Controller ses lumieres et ses stores depuis son telephone

## Avertissement pas du tout convivial
Je garantis que ce tuto recapitule les operations que j'ai du faire pour que ca marche chez moi, et absolument rien d'autre.
Je ne suis pas electricien, ni installateur de systeme domotique.
Je ne garantis pas que la methode soit la bonne, la plus simple ou la plus propre.
Si ca ne fonctionne pas, je ne garantis pas de faire le support.
Si suivre ce tuto entraine une electrocution, un incendie ou une pénurie de nutella je ne suis pas responsable.
Si ce tuto fonctionne et entraine une surcharge pondérale suite a une inactivité sur canapé, je ne suis pas responsable (mais solidaire par contre)
OK pour tous? alors on redevient convivial et on attaque

## Pré requis
Vous devez avoir chez vous:

 * une passerelle myHomeServer1 de bticino (voir plus bas)
 * une box internet avec un port réseau de libre, qui fournit un réseau wifi.
 * un telephone android (ou iOS, mais je n'ai pas testé)
 * un cable rj45 (fourni avec votre box, ou dispo sur [amazon])

## Installation de départ
Donc a priori, votre boitier electrique ressemble a ca (a une foret de cables pres):

![colonne][colonne]

De bas en haut:

 * La boite en bleu contient votre sortie fibre et les sorties réseau de l'appartement. votre boitier fibre doit y etre reliée et votre box n'est surement pas tres loin.
 * La boite en vert contient les disjoncteurs et des cables sous 220V de tension. on regarde, on touche pas et on passe a la suivante
 * Je passe aussi sur les compteurs, pas l'objet de ce tuto.
 * La boite en rouge est celle qui nous interesse:

a droite il y a la passerelle domotique. c'est ici que vous devez lire "myhomeserver1".

## Cablage
En devissant les 4 vis plastiques du boitier domotique et en retirant le boitier plastique, on trouve ça:

![boitier][boitier]

Sur le dessus de myhomeserver1, il y a une prise rj45 femelle dispo sur laquelle on branche une extremité de notre cable rj45.

Pendant que le boitier est retiré, notez l'user_code et le device_id sur l'etiquette collé devant.
Vous pouvez aussi noter l'installer_code qui chez moi avait été décollé et recollé a l'interieur du boitier plastique.

Maintenant on veut amener l'autre bout de cable a notre box. Là il y a deux manieres de proceder: la propre et la mienne.

La propre consisterait a ouvrir les autres boitiers de la colonne electrique pour faire passer le cable jusqu'en bas et qu'il ressorte au meme niveau que les arrivées réseau des differentes pieces.

La mienne consiste a refuser d'aller mettre les doigts dans des endroits que je ne maitrise pas (surtout quand ces endroits peuvent me tuer en fait). J'ai donc decoupé un bout du boitier aux ciseaux pour laisser passer le cable qui pendouillera le long de la colonne.
A vous de voir, mais rappel: 220V.

## Branchement
branchez le cable pendouillant sur un port disponible de votre box... c'est tout. les diodes sur le myhomeserver1 doivent s'allumer.

## Utilisation
Installez sur vos téléphones l'application [android] ou [iOS] MyHome_Up.
Le telephone connecté en wifi, lancez l'application et cliquez sur ajouter pour créer la connection. Selectionnez la votre (le device_id doit correspondre) et cliquez sur "je n'ai pas d'identifiants". Choisissez un nom de connexion et dans le champ PIN CODE entrez l'user_code noté auparavant. Cliquez sur "Sauve" pour enregistrer tout ça. Votre nouvelle connexion apparait dans la liste, cliquez dessus.

L'appli charge automatiquement vos pieces et commandes disponibles et vous pouvez directement allumer vos lumieres sans avoir a aller jusqu'a l'interrupteur (ce qui serait epuisant, convenons en).
Pour plus d'infos sur l'appli elle meme, la [doc officielle][MyHome_Up] est là pour vous.

Attention, si vous vous connectez avec l'installer_code vous aurez acces a beaucoup plus de fonctions: changer les comportements des interrupteurs pour fonctionner en minuteur par exemple ou meme modifier les liaisons entre interupteurs et lumieres. Vous aurez surtout dans vos telephones un moyen tres efficace de flinguer vos reglages electriques, donc soyez prudents.

## Bilan
Niveau installation rien à dire, tout etait là quand nous sommes arrivés. Je trouve bien normal que notre promoteur bien aimé economise un cable à 5 euros maximum. Et merci à eux pour nous avoir donné l'occasion d'aller bidouiller dans la colonne electrique pour pouvoir utiliser un systeme que nous avions payé.

Niveau utilisation, c'est franchement top. une fois cablé le controle sur le telephone est immediat, la configuration de scenario plutot simple.

A noter un petit defaut assez enervant: il y a une latence de 1 ou 2 secondes a l'execution de la premiere commande de la session. Les suivantes répondent par contre immediatement.

[android]: https://play.google.com/store/apps/details?id=com.bticino.myhomeevo&hl=fr
[iOS]:https://itunes.apple.com/fr/app/myhome-up/id1086592490?mt=8
[amazon]: https://www.amazon.fr/b/ref=s9_acsd_hfnv_hd_bw_bT7LaZ_ct_x_ct02_w?_encoding=UTF8&node=430306031&pf_rd_m=A1X6FK5RDHNB96&pf_rd_s=merchandised-search-8&pf_rd_r=ZXN1PEWE9R0M77PZGC99&pf_rd_t=101&pf_rd_p=e0e9cb9b-767e-5ad1-aa18-c77f14f3c384&pf_rd_i=430265031
[MyHome_Up]: https://www.bticino.be/fr/domotique/myhomeup
[colonne]: https://lh3.googleusercontent.com/FsuQOmHgQAV5DRNoGU0p5qNHIk_vyHZPYBUa7zowtQQpj3ppOxAI81Ps-oJSX62oA08ywGqYup_0bzNVd6ydq83ozB4N3r-iNZ5B45fj9xQY9wRF4Ayai0it2xmtro_BVmcCIBPwchEJX0o37bKpLXQsntc06hTmIekV3vhbZFHjK5WHWrvloiQ1o_g49p5kWTz8ZWvXdHykrLU0TmdzwlFurAEAdOGyjxq8Vmy6hHykIF2w_2rknGJwsOdvHoA5wLelQH0gIJ9UGhImRilxQBkCFqy3511xIb6KiQNo32DKokqzKVK5zjL3476igLfcLkiYxaB0EQuBLb9VWJprwgLnTVhOJQzTCNmsTNgFolpR53xVqiia3ofe8KTETcpPnclrGYD-BS83LnvfqPkvsXV6mv-xhuegxBjRr9bVOQPZ-3sI466eNcgflmUlxTF9R4LYtNNsO6iS0hPeI0gz4nTnyAsiW5b5RNAqBlvR2LoOQ0Phy_x-w-ok1k4qf5xJIvITwu-1fyK1OVQZdbiL7fAH4-Sg2INvR60O_6ZGF8-2KvAI8DklDXixsgs-YxSNtx6drxHXfq2EQTkoTss1bdX8fu8wfF4ydb3cTjjLBd8Ts6tlEC5GhKjpKzDnEMFH5k3BdkDLr1huNblRE7jkmpakIfeYnlAw=w500-h667-no "Colonne electrique"
[boitier]: https://lh3.googleusercontent.com/_4NAt0wQ6OZwhXNOJMClEbtd2qIJme8-ZckTMGbh9vrbN-THa2GftrIK6-quo_-hxzpavPsYJcgBgOtR49Wox4F0kUSxVd_skn8FuFPHI2y7__Hl4C0a4BAfxnKDcSPObfOqgA8583RkpLK9X120BqI3-8tQf0ZsSLGdbFvc5hKVqXZ1bhwbr2sTsOYKKH85QfKD2cbvl9_yS5m8MwHzHPOLBMC9SAQFQ8EGHS-YlBMQmz5qXJmnuo_CvSBbPRFlsMMvPgRcDvJZUpcVNmlbMaC010H3unRnsrUtmXFN_PJOFt-Or9Y60YY5PRFiZQxJnUnDWbkaFb5-6CMTblbvTW7LJLKrVcSPJgsbpV_VvfQkQc5Ez-2svvYia-iBXzZV0XKoAM2wMdt6nhHolanv9HxQBR40CFxVhF6eX6phdTjhtIvzkDUC0BgkNUInt8YjmLCclg8WCU9u1gkdj1D6T-CXacG255rsBmGu3sa0A-lfIKoBP9e0JPknZzTTIoIgNxJ11JZ-Kzr02mq1jZ1wS7BXas5o_ZwJLMTGnK8ollxRQCbZI4CU_8z1dvkhuVFwvgw2gqGUfG-rLbo7UQESgJsWg00-VNXdgVkCR6bhXFCQE-TEp_Bs25rggOgAWHF9l_EbDFOqkV7cU30FARRH8nG_XyOcnlzY=w500-h375-no "Boitier electrique"
