---
layout: post
title: Spell check for vim
lang: en
ref: spellcheck-for-vim
---

Vim is great, Vim is good. It's faster to learn how to use it than learn how to do without.

I write this site almost only with Vim so I need a functional spell check. Nothing to do, nothing to install: it's built in!

## How to stop and start spell checking

Start spell checking with

```
:set spell
```

Or with another language

```
:set spell spelllang=fr
```
(if it's your first time with this language, Vim will download every files you need)

Stop spell checking

```
:set nospell
```

## How to use

 * **]s** move to next error
 * **[s** move to previous error
 * **z=** suggest a list of alternatives
 * **zg** add the current word to dictionary
 * **zug** cancel dictionary update

## Spell check files automatically

To automatically spell check markdown files (.md), add this line to your ~/.vimrc

```
autocmd BufEnter *.md set spell
```
