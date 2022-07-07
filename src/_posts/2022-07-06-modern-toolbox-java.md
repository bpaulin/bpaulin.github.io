---
title: "Modern toolbox for java"
date: 2022-07-06
summary: Utilisation de k3d, jib et tilt pour un env de dev java
---

> [Code associé à cet article](https://github.com/bpaulin/modern-toolbox-java/tree/3bfaca2dde05cc9d3f2abbe057d585c8fb917245)

"Dis moi papy, comment tu faisais du dev quand t'étais jeune?"

"Installe toi petit, je vais te raconter une histoire avec virtualbox, vagrant et ansible"

"Pffff ca a l'air nul, moi j'aime les histoires avec docker"

"P'tit con"

...

Mon métier d'ops a considérablement évolué en quelques années, et celui des devs aussi. il est temps de me remettre a jour sur ce que ce serait un setup de dev moderne.

Un env de dev doit comme d'habitude concilier 2 points pas forcement conciliables. D'un coté, il doit être simple et rapide à installer et a utiliser. D'un autre coté, il doit être aussi proche de la prod que possible.

Je suis fan des repos auto-portants ou un git clone suffit a avoir tout pour installer, tester, deployer, documenter etc. Si le setup consiste a cloner et a copier/coller des instructions ca remplira le critère 'simple et rapide a utiliser'.

La prod aujourd’hui c'est kubernetes parce que c'est bien et surtout parce que sinon ca m’intéresse plus et l'article s’arrête ici. Le setup doit donc permettre de pop un cluster local et de deployer l'app dessus, toujours facilement et rapidement.

## Codons en java

Le code qui sera outillé sera du java juste parce que je déteste java. j'y comprends rien, donc ca m’intéresse pas, donc j'y comprends rien etc. Le point est que si l'env de dev est utilisable par moi, il le sera par n'importe qui.

Donc c'est parti, je vais coder en java ...

Spring a la bonne idée d'avoir [initialzr](https://start.spring.io/) qui permet de générer un projet rapidement sans la moindre compétence. La conf est même exportable via un lien avec les paramètres renseignés (group, artifact, dépendances etc) et celui de cet article est [ici](https://start.spring.io/#!type=maven-project&language=java&platformVersion=2.7.1&packaging=jar&jvmVersion=17&groupId=net.bpaulin&artifactId=modern-toolbox&name=modern-toolbox&description=Modern%20toolbox%20for%20java&packageName=net.bpaulin.modern-toolbox&dependencies=web,actuator)

Dans un repo fraîchement créé, je télécharge le zip et renomme le projet en **app**.

```bash
curl -o spring.zip 'https://start.spring.io/starter.zip?type=maven-project&language=java&bootVersion=2.7.1&baseDir=modern-toolbox-java&groupId=net.bpaulin&artifactId=modern-toolbox-java&name=modern-toolbox-java&description=Modern%20toolbox%20for%20java&packageName=net.bpaulin.modern-toolbox-java&packaging=jar&javaVersion=17&dependencies=web,actuator'
unzip spring.zip
mv modern-toolbox-java app
rm spring.zip
```

Pour vérifier que tout ce code difficilement écrit fonctionne, je passe dans le dossier et lance l'install du projet java.

```bash
cd app
mvn install
```

Et ainsi se terminer la partie java de cet article, c’était super.

## Image Docker

Dockeriser une application passe par le classique ajout d'un dockerfile mais on va essayer de faire un peu plus moderne et intégré en utilisant [Jib](https://github.com/GoogleContainerTools/jib), proposé par google.

 > Jib builds optimized Docker and OCI images for your Java applications without a Docker daemon - and without deep mastery of Docker best-practices. It is available as plugins for Maven and Gradle and as a Java library.

Pas de commandes docker a taper (plus rapide) ou meme a comprendre (plus simple), l'image docker devient un artefact du build java, comme un simple jar.

Jib ne nécessite pas d'install sur le poste, c'est simplement une dependance du projet à ajouter au **pom.xml** avec trois configuration importantes:

 * Le nom de l'image docker à créer: ici **modern-toolbox-java**
 * L'image de base à utiliser, par exemple ici pour partir d'une **eclipse-temurin:17.0.3_7-jre-alpine**
 * La phase de build ou on veut greffer le build de l'image, ici **packages**

```xml{8-29}
    <!-- ... -->
	<build>
		<plugins>
			<plugin>
				<groupId>org.springframework.boot</groupId>
				<artifactId>spring-boot-maven-plugin</artifactId>
			</plugin>
			<plugin>
				<groupId>com.google.cloud.tools</groupId>
				<artifactId>jib-maven-plugin</artifactId>
				<version>3.2.1</version>
				<configuration>
					<to>
						<image>modern-toolbox-java</image>
					</to>
					<from>
						<image>eclipse-temurin:17.0.3_7-jre-alpine</image>
					</from>
				</configuration>
				<executions>
					<execution>
						<phase>package</phase>
						<goals>
							<goal>dockerBuild</goal>
						</goals>
					</execution>
				</executions>
			</plugin>
		</plugins>
	</build>
    <!-- ... -->
```

Une fois jib configuré puis un ```mvn clean package``` lancé, on peut vérifier que l'image est connu de notre docker:

```bash
docker image ls | grep modern-toolbox-java | grep latest
# modern-toolbox-java                   latest                  bf5c41e987be   52 years ago    166MB
```

l'image peut être lancée a la main

```bash
docker run --rm -it  modern-toolbox-java:latest
#
#   .   ____          _            __ _ _
#  /\\ / ___'_ __ _ _(_)_ __  __ _ \ \ \ \
# ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \
#  \\/  ___)| |_)| | | | | || (_| |  ) ) ) )
#   '  |____| .__|_| |_|_| |_\__, | / / / /
#  =========|_|==============|___/=/_/_/_/
#  :: Spring Boot ::                (v2.7.1)
# ...
```


## Kubernetes local

Maintenant qu'on a une image docker, il nous faut un cluster pour nous accueillir. La page [Choosing a Local Dev Cluster](https://docs.tilt.dev/choosing_clusters.html) du site de tilt présente bien les différentes possibilités.

Pour ce projet, on va utiliser [k3d](https://k3d.io/v5.4.3/)  (k3s in docker). Les autres sont sûrement tres biens mais je les connais peu ou pas et k3d a plusieurs avantages:

 * Il se base sur [k3s](https://k3s.io/) que j'utilise sur mon cluster et dont je suis très content (subjectif, je sais).
 * k3s est léger et fourni directement pas mal de composants a installer sur kube ([traefik](https://traefik.io/) comme ingress controller par exemple).
 * Il ne nécessite qu'un binaire sur le poste (et un docker qui tourne bien sur)
 * Il est configurable via un fichier yaml versionnable par projet (plus simple et rapide)

En parlant de fichier yaml, on crée un fichier **k3d.yaml** à la racine du projet avec le contenu suivant:

```yaml
---
apiVersion: k3d.io/v1alpha4
kind: Simple
metadata:
  name: modern-toolbox-java
servers: 1
agents: 0
image: docker.io/rancher/k3s:v1.21.7-k3s1
registries:
  create:
    name: my-registry
options:
  k3d:
    wait: true
    timeout: "60s"
  kubeconfig:
    updateDefaultKubeconfig: true
    switchCurrentContext: true
```

Et toute l'installation et la configuration du cluster kube local devient une seule commande:

```bash
k3d cluster create -c k3d.yaml
```

Une fois la commande lancée notre context kube passe automatiquement vers le nouveau cluster, qui apparait dans la liste.

```bash
k3d cluster list
# NAME                  SERVERS   AGENTS   LOADBALANCER
# modern-toolbox-java   1/1       0/0      true
```

La manipulation du cluster via terminal est intuitive

```bash
k3d cluster start modern-toolbox-java   # Démarrage
k3d cluster stop modern-toolbox-java    # Arrêt
k3d cluster delete modern-toolbox-java  # Destruction
```

# Manifests

Maintenant qu'on a quelque chose a deployer et quelque part où le déployer, il nous reste à définir comment on déploie.

On parlera peut être plus tard de chart voir de helmfile mais on va commencer par un [deployment kubernetes](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) simpliste.

Au même niveau que notre dossier **app**, on crée le dossier **deploy** et un seul fichier: **manifests.yaml** qui décrit un pod simple sans replicas, n'ayant qu'un seul container issu de l'image construite précédemment.

```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: modern-toolbox-java
  labels:
    app: modern-toolbox-java
spec:
  replicas: 1
  selector:
    matchLabels:
      app: modern-toolbox-java
  template:
    metadata:
      labels:
        app: modern-toolbox-java
    spec:
      containers:
        - name: modern-toolbox-java
          image: modern-toolbox-java:latest
          ports:
            - containerPort: 8080
```

## Tilt pour le CD local

Tilt vient d'être racheté par docker, son rôle est de surveiller les sources d'une app et de lancer un build et un deploy quand ca bouge. Il fait pas grand chose, mais il le fait bien et il le fait vite. Leur département marketing le dit mieux que moi, évidemment:

> A toolkit for fixing the pains of microservice development.

> Are your servers running locally? In Kubernetes? Both? Tilt gives you smart rebuilds and live updates everywhere so that you can make progress.

A la racine du projet, dans un fichier **Tiltfile**, on va préciser les étapes de build et de deploy.

Le build a trois arguments: le nom de l'image, la commande à lancer et les dossiers a surveiller

```python
custom_build(
  'modern-toolbox-java',
  'mvn -f app/pom.xml compile jib:dockerBuild -Dimage=$EXPECTED_REF',
  deps=['app/src']
)
```

Le deploy est aussi simple que le manifest kube avec un seul argument

```python
k8s_yaml('deploy/manifests.yaml')
```

Tout est prêt, il n'y a plus qu'à lancer tilt et le laisser travailler

```bash
tilt up
# Tilt started on http://localhost:10350/
# v0.30.0, built

# (space) to open the browser
# (s) to stream logs (--stream=true)
# (t) to open legacy terminal mode (--legacy=true)
# (ctrl-c) to exit
```

Comme indiqué dans le retour de tilt, on peut suivre les logs simplement en pressant ```c``` et pour les plus amoureux de l'UI une jolie interface nous attends sur [http://localhost:10350/](http://localhost:10350/)

## Résumé

Pour lancer un env de dev local, vous devez avoir sur votre poste:

 * docker, installé et accessible par votre user
 * mvn (c'est à dire que c'est un projet java, faites un effort)
 * k3d ([Docs](https://k3d.io/v5.4.3/) / [Install](https://github.com/k3d-io/k3d/releases)) pour le cluster local
 * tilt ([Docs](https://docs.tilt.dev/) / [Install](https://github.com/tilt-dev/tilt/releases)) pour le cd/cd

Clonez le repo

```bash
git clone https://github.com/bpaulin/modern-toolbox-java.git
```

Démarrez le cluster

```bash
k3d cluster create -c k3d.yaml
```

Lancez la surveillance

```bash
tilt up
```

> [Code associé à cet article](https://github.com/bpaulin/modern-toolbox-java/tree/3bfaca2dde05cc9d3f2abbe057d585c8fb917245)
