---
title: Migration de jekyll vers vuepress
date: 2022-06-29
summary: 'github pages est mort, longue vie à github pages'
---

Ce site est né sous worpress il y a des années, jusqu'a ce que github me fasse decouvrir github pages. Github pages me donne un site versionné, facile à écrire, avec des thèmes suffisament beaux pour mes besoins très limités. Le plus beau est que tout ça se fait gratuitement, sans hébergment à payer ou gérer.

Le seul problème est le générateur utilisé, jekyll. Il est sommaire (mais vu l'ambition extremement faible de ce site c'est suffisant), il ne fait que du html statique (un peu de js, une barre de recherche, etc sont quand meme appréciable) mais surtout: c'est du ruby.

Je ne connais pas ruby, ca ne m'interesse pas et/parce que à part jekyll je n'en ai aucun usage. J'avais galéré à setup un env de dev sous archlinux et depuis ma migration vers nixos je n'ai aucune envie de passer quelques heures a comprendre les gems, bundle, ruby2, ruby3 et le reste dont j'ignore l'existence.

Encore plus facilement maintenant avec github actions, il existe des alternatives: github publiera n'importe quelle site statique dans un sous dossier ou une branche dédiée. N'importe quel générateur de site statique fera l'affaire... et ca sera [vuepress](https://vuepress.vuejs.org/)

Il suffit d'avoir yarn et node sur mon poste, et je peux y aller.

## Création du projet

Je laisse yarn me créer le projet, en repondant aux quelques questions (nom, description, etc). Le questions ne servent qu'a remplir **package.json**, tout est modifiable ensuite

```bash
yarn create vuepress-site
```

Une fois la commande terminée un dossier **docs** apparait avec les sources de vuepress, je vais dedans:

```bash
cd docs
```

Dans l'état vuepress m'a fourni un site classique. Via la commande suivante, je le trnasforme en blog en ajoutant le [plugin](https://vuepress-plugin-blog.billyyyyy3320.com/) et le [theme](https://vuepress-theme-blog.billyyyyy3320.com/)

```bash
yarn add -D @vuepress/plugin-blog @vuepress/theme-blog
```

Il reste a configurer le plugin, en lui indiquant que les posts seront dans le dossier **_posts**

```js{6-17}
module.exports = {
  // ...
  plugins: [
    '@vuepress/plugin-back-to-top',
    '@vuepress/plugin-medium-zoom',
    [
      '@vuepress/blog',
      {
        directories: [
          {
            id: 'post',
            dirname: '_posts',
            path: '/',
          },
        ],
      },
    ]
  ]
  // ...
}
```

la configuration du theme est encore plus simple. Dans un premier temps je configure juste les liens header et footer, ainsi que le format de date.

```js{3-21}
module.exports = {
  // ...
  theme: '@vuepress/blog',
  themeConfig: {
    // Please head documentation to see the available options.
    dateFormat: 'YYYY-MM-DD',
    nav: [
      {
        text: 'Articles',
        link: '/',
      },
    ],
    footer: {
      contact: [
        {
          type: 'github',
          link: 'https://github.com/bpaulin',
        },
      ],
    },
  },
  // ...
}
```

## Import des posts jeckyll

J'ai mon dossier _posts a la racine et vuepress attends _posts dans src/, il suffit maintenant de déplacer

```bash
mv ../_posts src/
```

Dans mon cas les articles n'avaient pas ou peu de frontmatter, j'ai du passer sur chacun pour rajouter les infos minimales. Par exemple:

```yaml
---
title: IaaS/Caas et petite fille
date: 2021-09-28
summary: ' '
---
```

C'etait un peu laborieux, mais pour le faible nombres d'articles ca ne valait pas le coup de chercher a automatiser.

Maintenant le blog est censé etre ok, il est consultable localement en tapant:

```
yarn dev
```

## Nettoyage jekyll

On remonte à la racine:

```bash
cd .. && ls
```

Hormis le dossier docs, evidemment, tout doit disparaitre. A ce stade, tout ce qui n'est pas dans le dossier docs n'est qu'un relicat de jekyll. J'ai pu tout supprimer via cette commande:

```bash
rm -rf \
    _drafts \
    _config.yml \
    .gitignore \
    *.md \
    Gemfile
```

On n'a plus besoin du dossier intermediaire, je remonte tout ce qu'il contient à la racine et je le supprime:

```bash
mv docs/.* .
mv docs/* .
ls -la docs/
rmdir docs
```

## Confort d'ecriture via vscode

Pour m'assurer que le code est propre et me faciliter la vie, je vais laisser les extensions markdown et vue faire leur travail a chaque enregistrement.

dans le fichier **.vscode/settings.json**:

```jsonc
{
    "editor.formatOnSave": true,
}
```

C'est leger, mais ca suffira largement

## Publication

On a un code qui peut generer un site, ... , et github qui est pret a publier un site.

Dans les settings du projet, je set le deploiement de **/** de la branch **gh-pages** (qui n'a pas besoin d'exister initialement)

Et pour finir, je config github actions pour generer le site a partir de la branch **main** et le commiter dans **gh-pages** pour lier le tout.

dans le fichier **.github/workflows/publish.yml**:

```yaml
name: publish to gh pages
"on":
  push:
    branches:
      - main
jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@master

      - name: Build and Deploy
        uses: jenkey2011/vuepress-deploy@master
        env:
          ACCESS_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          # le repo du site
          TARGET_REPO: bpaulin/bpaulin.github.io
          TARGET_BRANCH: gh_pages
          BUILD_SCRIPT: yarn && yarn build
          BUILD_DIR: src/.vuepress/dist/
          # uniquement parce que j'ai un domaine
          # sinon bpaulin.github.io sera utilisé
          CNAME: www.bpaulin.net
```
