---
title: CI terraform
date: 2022-09-10
summary: Même les outils de déploiements méritent une CI
---

J'aime pas terraform. Je n'ai jamais compris l'interet du tfstate mais j'en ai déja subi les inconvenients. Je ne suis même pas convaincu de l'interet du produit: pourquoi utiliser un outil qui peut tout faire pour des envs mono cloud, pourquoi ne pas utiliser directement les api ou cli fournis par ce même cloud provider.

Sauf que...

Si autant l'utilisent c'est soit que je suis le seul à avoir raison (donc non) soit que j'ai tord. Terraform est devenu de facto l'outil pour créer des resources cloud, et les recruteurs le demandent(...).

 > Si c'est pas versionné, c'est nul. si c'est versionné, ca doit avoir un CI

Donc youpi, side project #78587: le CI d'un projet terraform

## Projet terraform

Totalement par hasard et sans lien avec des discutions récentes(...) je vais partir sur la création d'un cluster eks, le kube managé sur aws.

Toujours par hasard, hashicorp utilise justement ce cas dans leurs tutos, quel incroyable coincidence! A se demander si j'ai pas choisi ca pour pouvoir aller plus vite vers la partie qui m'interesse aujourd'hui

Un fork de https://github.com/hashicorp/learn-terraform-provision-eks-cluster sur mon github, un clone local et je peux avancer.

L'authentification sur aws n'est pas le sujet, je passe la creation des clés mais je les exporte dans mon shell.

```bash
export AWS_ACCESS_KEY_ID="cestsecret"
export AWS_SECRET_ACCESS_KEY="cestsupersecret"
```

J'initialise terraform. Dans ce cas simpliste, c'est un grand mot pour dire que terraform va télécharger les providers demandés (aws en particulier). Pour cet article, je me rajoute une contrainte: autant que possible, les outils doivent être lancé via docker sans installation locale.

```bash
docker run --rm -it \
  -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
  -v "$(pwd):/src" -w '/src' \
  hashicorp/terraform:1.2.9 \
  init
```

Et je ```plan``` terraform, pour tester la communication avec aws et voir ce qu'il va me créer.

```bash
docker run --rm -it \
  -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
  -v "$(pwd):/src" -w '/src' \
  hashicorp/terraform:1.2.9 \
  plan
```

Le log me montre tout ce qui va être créé, à savoir pleins de trucs.

```
Plan: 56 to add, 0 to change, 0 to destroy.
```

C'est trop facile terraform, quel scandale d'être payé autant pour faire du copier coller

> The beauty and clearness of the dynamical theory, which asserts heat and light to be modes of motion, is at present obscured by two clouds.

2 petits nuages restent, 2 minuscules nuages:

 * Est ce que c'est prod ready? (n'importe quel tutoriel trouvé sur internet est prod ready, ne soyons pas parano)
 * Combien ca va couter? (surement quasiment rien, pas d'inquietude)

## Prod ready?

Clairement, une analyse statique du code ne couvrira qu'une partie des problèmes. Le sizing de l'infra va se manger la réalité pleine gueule. Les perfs seront à revoir, la résilience sera à tester. Chaque 0.1% de dispo va couter plus cher que le précédent, Chaque évolution des technos et des versions vont remettre en cause ce qu'on croit savoir.

Par contre l'analyse statique de code a un avantage incomparable: avec très peu d'effort, on couvre 90% (random chiffre, basé sur 'vas y crois moi') des failles/erreurs de conception ou d'implementation. Par definition on peut lancer ces analyses sans meme avoir besoin de commencer a payer les evols. Et surtout, surtout! on se base sur des règles et pratiques issues de la communautée mondiale des users, forcement plus fiables que celles qu'un unique reviewer aura en tete.

### tflint, pour du code 'bien' ecrit

> TFLint is a framework and each feature is provided by plugins, the key features are as follows:
>
>   * Find possible errors (like invalid instance types) for Major Cloud providers (AWS/Azure/GCP).
>   * Warn about deprecated syntax, unused declarations.
>   * Enforce best practices, naming conventions.

C'est bien ecrit hein? c'est un readme, c'est normal. tflint va me permettre sans efforts et rapidement de verifier que les evols de mon code n'apportent pas une erreur. En bonus, tflint va vérifier les bonnes pratiques pour les 3 principaux cloud providers occidentaux (aws, gcp, azure).

La config est rapide, j'indique juste dans le fichier ```.tflint.hcl``` que je veux qu'il analyse la structure terraform et les resources aws.

```hcl
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
}
```

Le lancement, comme pour terraform, se fait via docker:

```bash
docker run --rm -t \
  -v $(pwd):/data \
  ghcr.io/terraform-linters/tflint-bundle:v0.40.1.0
```

et paf, mon code n'est pas aussi propre que je pensais :(

```
1 issue(s) found:

Warning: Missing version constraint for provider "kubernetes" in "required_providers" (terraform_required_providers)

  on main.tf line 6:
   6: provider "kubernetes" {

Reference: https://github.com/terraform-linters/tflint-ruleset-terraform/blob/v0.1.1/docs/rules/terraform_required_providers.md
```

J'ai effectivement un petit problème: ma version du provider kube est totalement libre, je prends le risque d'une execution sur une version jamais testée, ou trop vieille. tflint me donne meme un lien qui m'explique quoi faire. La correction est simple, il suffit d'editer le fichier ```versions.tf```

```hcl
terraform {
  required_providers {
    # ...
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.13.0"
    }
    # ...
  }
}
```

et tflint ne trouve plus rien a dire, un [commit](https://github.com/bpaulin/learn-terraform-provision-eks-cluster/commit/78c78a2e36984b0ad256b3095fbf0fd5c2748478) et on enchaine avec l'outil suivant

### tfsec, DevSecOps

tfsec va faire la meme chose que tflint, mais plus axé sur les eventuels problèmes de sécurité. Le lancement, comme toujours, n'a besoin que de docker. Très confiant sur la sécurité poussée d'un tutoriel trouvé sur internet, je lance la commande

```bash
docker run --rm -it \
  -v "$(pwd):/src" \
  aquasec/tfsec:v1.27 \
  /src
```

```
  results
  ──────────────────────────────────────────
  passed               38
  ignored              0
  critical             5
  high                 2
  medium               2
  low                  4

  38 passed, 13 potential problem(s) detected.
```

13 failles, 5 critiques... oh bah large, allons en prod rassurés. tfsec permet un export markdown, entre autre, qui me permet de detailler tout ca

| #   | ID                                               | Severity   | Title                                                                      | Location                                                                      | Description                                                              |
| --- | ------------------------------------------------ | ---------- | -------------------------------------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| 1   | `aws-ec2-add-description-to-security-group`      | *LOW*      | _Missing description for security group._                                  | `security-groups.tf:16-29`                                                    | Security group explicitly uses the default description.                  |
| 2   | `aws-ec2-add-description-to-security-group`      | *LOW*      | _Missing description for security group._                                  | `security-groups.tf:1-14`                                                     | Security group explicitly uses the default description.                  |
| 3   | `aws-ec2-add-description-to-security-group-rule` | *LOW*      | _Missing description for security group rule._                             | `security-groups.tf:5-13`                                                     | Security group rule does not have a description.                         |
| 4   | `aws-ec2-add-description-to-security-group-rule` | *LOW*      | _Missing description for security group rule._                             | `security-groups.tf:20-28`                                                    | Security group rule does not have a description.                         |
| 5   | `aws-ec2-no-public-egress-sgr`                   | *CRITICAL* | _An egress security group rule allows traffic to /0._                      | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/node_groups.tf:182` | Security group rule allows egress to multiple public internet addresses. |
| 6   | `aws-ec2-no-public-egress-sgr`                   | *CRITICAL* | _An egress security group rule allows traffic to /0._                      | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/node_groups.tf:182` | Security group rule allows egress to multiple public internet addresses. |
| 7   | `aws-ec2-no-public-egress-sgr`                   | *CRITICAL* | _An egress security group rule allows traffic to /0._                      | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/node_groups.tf:182` | Security group rule allows egress to multiple public internet addresses. |
| 8   | `aws-ec2-no-public-ip-subnet`                    | *HIGH*     | _Instances in a subnet should not receive a public IP address by default._ | `terraform-aws-modules/vpc/aws/src/.terraform/modules/vpc/main.tf:359`        | Subnet associates public IP address.                                     |
| 9   | `aws-eks-enable-control-plane-logging`           | *MEDIUM*   | _EKS Clusters should have cluster control plane logging turned on_         | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/main.tf:14-63`      | Control plane controller manager logging is not enabled.                 |
| 10  | `aws-eks-enable-control-plane-logging`           | *MEDIUM*   | _EKS Clusters should have cluster control plane logging turned on_         | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/main.tf:14-63`      | Control plane scheduler logging is not enabled.                          |
| 11  | `aws-eks-encrypt-secrets`                        | *HIGH*     | _EKS should have the encryption of secrets enabled_                        | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/main.tf:14-63`      | Cluster does not have secret encryption enabled.                         |
| 12  | `aws-eks-no-public-cluster-access`               | *CRITICAL* | _EKS Clusters should have the public access disabled_                      | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/main.tf:26`         | Public cluster access is enabled.                                        |
| 13  | `aws-eks-no-public-cluster-access-to-cidr`       | *CRITICAL* | _EKS cluster should not have open CIDR range for public access_            | `terraform-aws-modules/eks/aws/src/.terraform/modules/eks/main.tf:27`         | Cluster allows access from a public CIDR: 0.0.0.0/0.                     |

Le cluster est public, les secrets sont en clair, le logging n'est pas activé... sans maitriser aws, il va falloir faire l'effort de regler chque problème ou si on peut **vraiment** le justifier, annoter les tf pour exclure une remontée.

Je suis surpris du nombre de failles trouvées, il y en a trop pour détailler la resolution ici. Je le ferai peut etre un jour (ahahah non, je vais passer sur sideproject #85379876 c'est plus probable).

## infracost, le nerf de la guerre

Evidemment que le cloud est génial, c'est reactif, moderne, facile. On peut heberger n'importe quoi sur n'importe quel techno avec n'importe quelle puissance en quelques lignes de codes... et à la fin du mois, on recoit la facture. C'est le cofidis des datacenters, une reserve de puissance phenomenale accessible facilement... et un cout qui peut s'envoler tres haut, tres vite, trop tard.

Mais comme il existe des apps pour suivre et prevoir un budget (...) il existe une app pour prevoir les couts du cloud.

Infracost fournit pleins de trucs, des abonnements avec des dashboards pour suivre l'evolution des couts. Pour mon cas, je vais juste utiliser leur cli pour avoir une idée du cout de ce petit tutoriel bien ecrit (oui) et sans failles (non).

Il faut une api key meme pour le free tier, que je pose en var d'env dans mon shell

```bash
export INFRACOST_API_KEY=olalalacestsecret
```

Et comme precedemment, le lancement se fait via docker

```bash
docker run --rm \
  -e INFRACOST_API_KEY \
  -v $PWD/:/code/ infracost/infracost:ci-0.10.11 \
  breakdown --path /code/
```

```
 OVERALL TOTAL                                                                                                      $170.24
──────────────────────────────────
53 cloud resources were detected:
∙ 6 were estimated, 4 of which include usage-based costs, see https://infracost.io/usage-file
∙ 47 were free, rerun with --show-skipped to see details
```

$170 par mois! et encore, infracost me signale que certaines resources sont facturées a l'usage et ne sont pas dans le chiffrage.

## Ensuite?

Tout ces outils s'integrent via github actions, mais cet article est deja assez long.
