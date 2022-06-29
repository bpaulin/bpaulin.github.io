---
title: Détecteur de mensonge avec 9 cartes
date: 2017-01-19
summary: ' '
---

Les maths, c'est magique et la magie c'est souvent des maths.

Par exemple, l'excellente chaine numberphile montre ce tour:

<iframe class='ytiframe' width="560" height="315" src="https://www.youtube.com/embed/Dawf6I9tNU4" allowfullscreen></iframe>

Le problème ici est la cible habituelle de mes tours: les gamins. Ces monstres refusent d'être bilingue sous pretexte qu'ils ont moins de 10 ans (à mon avis, c'est surtout un problème d'éducation).

En français, le tour a planté quelque fois. le script suivant m'a servi à comprendre dans quel cas:

```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-

numbers = ('as', 'deux', 'trois', 'quatre', 'cinq',
	'six', 'sept', 'huit', 'neuf', 'dix',
	'valet', 'dame', 'roi')
colors = ('pique', 'coeur', 'trefle', 'carreau')

def rotate(total, current, word):
	letters = len(word)
	if (letters<current):
		return current-letters
	return total-current+1

for color in colors:
	current=3
	for number in numbers:
		first=rotate(9, current, number)
		second=rotate(9, first, 'de')
		last = rotate(9, second, color)
		if (last!=5):
			print number,'de',color,'=>',last
```

Au final, la cible ne peut pas choisir un as. Avec un peu de random bullshit, on évite ce choix et on voit la joie dans les yeux d'un enfant... 2 secondes, le temps qu'il retourne jouer sur sa tablette.
