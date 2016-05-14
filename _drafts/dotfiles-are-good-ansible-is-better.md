---
layout:     post
title:      dotFiles are good, ansible is better
lang:       en
ref:        dotfiles-are-good-ansible-is-better
---

On Linux, everything is configured with plain text files, even softwares witch provide a shiny configuration GUI.
Plain text files means git, period.

I think every one in IT should have a dotFiles repository, for two reasons.

 1. Configuration can be shared easily from one system to another. Did you add a useful git alias at work? You can get it at home with one single command. Did you just but a new laptop? One command and it will feel just as your old one.
 2. Speaking about git alias and bash config, obviously you won't be able to install your config on every system you'll use. If you have your dotFiles in a public github repository, you'll always be one copy/paste away from every alias you love.

I have hosted [mine on github][dotFiles] since more than 2 years, and I am (was) really happy about it. It contains my configuration for Vim, zsh, git, etc. It also contains my config files for openbox, tint2 and everything I use when terminal is not enough.

For 2 years and for every system I've worked on, it was always the same: use apt or yum to install packages I knew I needed, launch a small script to link every file, reboot & profit.

'packages I knew I needed'... That was a mistake. Every now and then I find a new package to install and to try. Too often, I use it in scripts and/or dotFiles without even thinking about my others systems. And too often, these systems broke after updating dotFiles.

DotFiles is not enough, I need something that can install and configure anything ... And that's what provisioning is.

My previous experiences with provisioning for vagrant were not a real success.

I tried bash, the easiest one. It was OK, it did what I was asking. But after a while, scripts became huge and ugly. Scripting only a simple LAMP server results in a unreadable script.

I tried puppet and chef. I spent too many hours to have a valid cookbook. OK, it worked but I didn't like it because I hadn't the feeling that I really understood it. Every few months, I told myself that I should retry. 


Recently I had to play with ansible at work. This, I loved.

Pros:

 * easy to learn (documentation is very clear, and getting started is a matter of minutes)
 * easy to begin (you can just script shell commands to begin if you want, and use module after when you've realized shell is not the best way)
 * easy to use (a simple command)
 * use cowsay when available (OK, useless but funny)

Cons:

 * impossible to install on windows (but if it's for a vagrant VM, a simple script can install ansible on the VM and let the magic be done on it)

And so... [my dotFiles are now made with ansible][dotFiles_Ansible]

To begin, my goal was simple: I began with a clean debian 8 VM on amazon ec2 and I wanted to write this post!

This website is hosted on github (so I need git), built with jekyll (ruby it is), checked with grunt (nodejs, I missed you) and written with Vim. And I want my shiny terminal with zsh.
And i'm writing this post on a fresh VM made by ansible!

[dotFiles]: https://github.com/bpaulin/dotFiles
[dotFiles_Ansible]: https://github.com/bpaulin/DotFiles_Ansible

