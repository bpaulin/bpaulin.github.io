---
title: "Backstage.io: Infrastucture"
date: 2022-07-01
summary: Création d'un redis, d'un postgres et d'un cluster kube sur gcp avec terraform
---

> [Code associé à cet article](https://github.com/bpaulin/poc-backstage/tree/33628f40058e339d36a227c28a5dfd1a8adf07af)

Pour d'obscures raison, j'entends beaucoup parler de [backstage](https://backstage.io) ces derniers temps. Je ne pense vraiment pas en avoir l'utilité pour mon usage personnel mais ca me fait un machin geek à faire de mon canapé!

Parce que installer un soft c'est pas de qu'il y a de plus motivant, j'ai d'autres objectifs/contraintes:

 * Je veux une vraie infra cloud: les datas en paas, l'applicatif en caas
 * Vu que ca ne rentrera pas dans un tier gratuit, je veux pouvoir créer le projet rapidement et le detruire completement à volonté.
 * Je veux un projet entierement versionné et automatisé. chaque clic sur une ihm sera un echec
 * Je veux quelque chose de très très simple, sans scalabilité et meme sans perf. je vais payer a l'heure et c'est juste un poc

Concrètement je vais utiliser:

 * [gcloud](https://cloud.google.com/sdk/gcloud) pour m'authentifier sur gcp
 * [terraform](https://www.terraform.io/) pour deployer l'infra
 * ... et a priori c'est tout

Pour créer:

 * une db postgres en paas
 * une instance en paas
 * un cluster gke

Une fois le projet créé sous gcp, associé a un compte de facturation, tout est pret

## Structure

Pour la suite, 2 vars d'env doivent etre définies. dans un **.envrc** ignoré par git par exemple:

```bash
export TF_VAR_gcp_project=my-wonderful-project-1234
export TF_VAR_gcp_region=europe-west3
```

Terraform a (la mauvaise d'idée d'avoir) besoin de stocker l'état de l'infra dans un fichier tfstate. Ce fichier sera utilisé en tant que source de vérité pour que terraform décide de ce qu'il a à faire.

Pour permettre une portabilité de ce projet d'un laptop à un autre, et plus tard vers un ci type github action, ce tfstate sera lui meme sur gcp.

Il y aura donc 2 dossier terraform:

 * le premier pour créer le storage, sans upload du tfstate. Cette partie sera executée une fois et a priori jamais supprimée
 * le 2ème pour réellement créer l'infra, et dont le tfstate sera sur le storage du 1er

Je commence par me logguer sur gcp

```bash
gcloud auth login
```

et me placer sur le projet gcp voulu

```bash
gcloud config set project $TF_VAR_gcp_project
```


## Terraform backend

### Code

Dans un dossier dédié, par exemple ```mkdir -p terraform/backend```, j'ai besoin d'un seul fichier **main.tf** avec les instructions suvantes:

Pour commencer, j'indique que ce tf a besoin du [provider google](https://registry.terraform.io/providers/hashicorp/google/latest/docs) et je fixe la derniere version a date, la 4.27.0

```hcl
terraform {
  required_providers {
    google = {
      source  = "google"
      version = "4.27.0"
    }
  }
}
```

Ensuite, je déclare les 2 variables nécessaires au déploiement: gcp_projet et gcp_region. Terraform ira chercher les valeurs via les vars d'env TF_VAR_ set au chapitre précédent.

```hcl
variable "gcp_project" {
  type = string
}
variable "gcp_region" {
  type = string
}
```

J'ai maintenant tout pour configurer le provider google

```hcl
provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
```

Et, enfin, la création du storage a proprement parler:

```hcl
resource "google_storage_bucket" "tfstate" {
  name     = "backstage-gcs"
  location = var.gcp_region
}
```

### Application

Initialiser terraform (télécharger les providers, init le tfstate local, etc)

```bash
terraform init
```

Appliquer les changements:

```bash
terraform apply
```

Ce projet n'a pas de tfstate distant donc si je change de laptop, je devrais importer la resource avant toute modification


```bash
terraform import google_storage_bucket.tfstate backstage-gcs
```

## Infrastructure

### Backend et provider

Dans un autre dossier, par exemple ```mkdir -p terraform/deploy```, j'ai besoin d'un autre fichier **main.tf**. Tout le début du fichier est le même que celui du backend pour installer et configurer le provider et declarer les variables:

```hcl
terraform {
  required_providers {
    google = {
      source  = "google"
      version = "4.27.0"
    }
  }
}

variable "gcp_project" {
  type = string
}

variable "gcp_region" {
  type = string
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
```

Ce projet utilisera un backend distant, que je configure en précisant le nom du storage precedemment créé et le path (ici /tfstate/) a l'intérieur duquel terraform ecrira son tfstate.

```hcl
terraform {
  backend "gcs" {
    bucket = "backstage-gcs"
    prefix = "tfstate"
  }
}
```

### Redis

Aucune difficultée pour l'instance redis, je doit juste préciser la taille (le minimum et donc le moins cher = 1Gio)

```hcl
resource "google_redis_instance" "cache" {
  name           = "backstage-redis"
  memory_size_gb = 1
}
```

### Postgres

Gcp n'authorise pas la création d'une base si une autre base du même nom est supprimée depuis moins d'une semaine. C'est très pratique pour du disaster recovery mais ca ne m'arrange pas: Je veux payer la base QUE quand je m'en sers. Je vais souvent la supprimer un soir pour la recréer le lendemain donc je dois changer le nom à chaque fois.

Une solution pour ça est de passer par une chaine de charactere au hasard, fournie par le provider [random](https://registry.terraform.io/providers/hashicorp/random/latest/docs) que j'ajoute à mes pré-requis

```hcl{4-7}
terraform {
  required_providers {
    // ...
    random = {
      source  = "random"
      version = "3.3.2"
    }
    // ...
  }
}
```

je peux maintenant déclarer une nouvelle resource **random_string**. Cette resource sera set à chaque création de l'infra, sera ajoutée au tfstate et pourra donc servir aussi a identifier la base a supprimer.

4 caractères suffiront, et uniquement des minuscules:

```hcl
resource "random_string" "dbname" {
  length  = 4
  upper   = false
  special = false
}
```

Je peux maintenant créer la base et l'instance, en supprimant la protection contre la suppression (le monde merveilleux des POC!) et en lui mettant la taille la plus petite et le disque le moins rapide (le monde merveilleux des side-projects!)

```hcl
resource "google_sql_database" "database" {
  name     = "backstage-db"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  name                = "backstage-db-instance-${random_string.dbname.result}"
  database_version    = "POSTGRES_14"
  deletion_protection = false
  settings {
    tier      = "db-f1-micro"
    disk_type = "PD_HDD"
  }
}
```

### Kubernetes

Objectivement, créer UN cluster pour UNE app est un non sens absolu mais parce que je veux un projet totalement autonome, que je veux montrer que c'est faisable et que c'est moi qui décide... je crée un cluster

je fais au plus simple, en créant un cluster autopilot (gcp gère tout et me facture au cpu/ram)

```hcl
resource "google_container_cluster" "primary" {
  name             = "backstage-gke"
  location         = var.gcp_region
  enable_autopilot = true
  ip_allocation_policy {}
}
```

### Application

Initialiser terraform (télécharger les providers, init le tfstate gcs, etc)

```bash
terraform init
```

Appliquer les changements (le faire 2 fois pour vérifier l'idempotence). A itre d'information, l'opération prend une dizaine de minutes

```bash
terraform apply
```

Et surtout, surtout! ne pas oublier une fois le geekage fini de tout supprimer. A titre d'information, l'opération prend 2/3 minutes.

```bash
terraform destroy
```

> [Code associé à cet article](https://github.com/bpaulin/poc-backstage/tree/33628f40058e339d36a227c28a5dfd1a8adf07af)
