# OPC2 - Entraînez-vous avec SQL et créez votre BDD

## Présentation

### Qu’allez-vous apprendre dans ce projet ?

Vous avez découvert les bases du langage Python dans le projet précédent.

Si vous souhaitez ancrer votre apprentissage, vous pouvez vous entraîner à l’aide de [ces questions](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/Entrai%CC%82nez+votre+me%CC%81moire_P3.pdf), sinon il est temps de passer à la suite !

Dans ce projet, vous allez consolider vos compétences et réaliser une base de données.

Vous allez apprendre la modélisation d’une base de données et extraire vous-même des données de cette base en utilisant le langage SQL.

### En quoi ces compétences sont-elles importantes pour votre carrière ?

Ces compétences sont utiles pour l’ensemble des personnes qui travaillent dans l’analyse des données. Maîtriser le SQL est une des compétences les plus importantes car cela permet d’extraire les données avant de pouvoir les analyser ou les transformer.

Ce langage de programmation est présent dans l’ensemble des offres d’emploi sur le marché du travail.

### Comment allez-vous procéder ?

Ce projet est découpé en 2 activités : cours et exercice.

- **Cours** :
  - Vous consulterez la ressource pédagogique intitulée “Lexique et Notions clés” si vous débutez en base de données.
  - Vous suivrez 2 cours :
    - [Modélisez vos bases de données](https://openclassrooms.com/fr/courses/6938711-modelisez-vos-bases-de-donnees) pour vous permettre de comprendre les enjeux de la découverte des données, les différentes clés et les schémas de bases de données.
    - [Requêtez une base de données](https://openclassrooms.com/fr/courses/7818671-requetez-une-base-de-donnees-avec-sql) afin d’apprendre le langage des bases de données : le SQL.
- **Exercice en 3 parties** :
  - Partie 1 : Comprenez des données et créez un schéma relationnel.
  - Partie 2 : Créez une base de données et chargez des données.
  - Partie 3 : Utilisez du SQL pour extraire des données et présentez vos résultats.

Vous terminerez en complétant la fiche d’autoévaluation qui servira de base de discussion et de bilan avec votre mentor.

À l’issue de ce projet, vous aurez une **session de bilan** avec votre mentor pour discuter de votre projet.

Cela vous assurera que vous êtes sur la bonne voie avant de passer à la suite.

### Prêt à démarrer votre projet ?

Lancez-vous dans la première section : Ressource pédagogique.

>[!Note]
>Votre projet démarre : suivez ces quelques recommandations pour être plus efficace !
>
>- **Coupez** dès à présent toutes les sources de distraction : téléphone, messagerie, mails, notifications, etc.
>- **Évitez** les situations de multi tâches : n’écoutez pas un podcast ou les informations en travaillant.
>- **Préparez** votre environnement de travail : onglets, documents téléchargés, raccourcis, etc.
>
>Vous avez toutes les cartes en main, c’est parti !
>
>Pour plus de conseils, suivez ce chapitre de cours : [Mettez en place votre environnement d'apprentissage](https://openclassrooms.com/fr/courses/4312781-apprenez-a-apprendre/4790751-mettez-en-place-votre-environnement-dapprentissage).

#### Objectifs pédagogiques

---

>[!TIP]
>Créer des bases de données relationnelles afin de contenir les données

>[!TIP]
>Structurer les données et leurs relations en cohérence avec leurs caractéristiques

## Contenu

### Ressource pédagogique pour débutants - Lexique et notions clés des bases de données

---

#### Pourquoi consulter cette ressource ?

---

Vous allez découvrir le lexique des bases de données.

Pour télécharger la ressource, cliquez sur l’image ci-dessous.

![alt text](image.png)

### Cours - Modélisez vos bases de données & Requêtez une base de données

---

#### Pourquoi suivre ces cours ?

---

Vous allez découvrir comment **modéliser** et **utiliser** une **base de données** :

>[!Note]
>Avant d'utiliser une base de données, il faut la modéliser.

Durant cette phase, vous allez appréhender les différentes **étapes** à mettre en place pour construire et structurer une base de données :

1. Repérer les différentes variables et rédiger le dictionnaire des données.
2. Construire le schéma relationnel en respectant les normes NF et créer la base de données.

Pour découvrir la modélisation des bases de données, commencez par ce cours :

>Cours [Modélisez vos bases de données](https://openclassrooms.com/fr/courses/6938711-modelisez-vos-bases-de-donnees)

>[!Note]
>Une fois que ces concepts de base sont acquis, vous pourrez effectuer des requêtes dans votre base avec le langage **SQL**.

Le SQL permet d’**extraire des données** de votre base en les sélectionnant et en ajoutant des filtres pour extraire les données pertinentes.

Pour découvrir le langage des bases de données, le SQL, suivez ce cours :

>Cours [Requêtez une base de données avec SQL](https://openclassrooms.com/fr/courses/7818671-requetez-une-base-de-donnees-avec-sql)

#### Sur quelles parties devez-vous vous focaliser ?

---

Pour le **cours “Modélisez vos bases de données”** : si vous débutez dans la modélisation des bases de données, vous devez rester attentif à **l’ensemble du cours**.

>[!Note]
>Ce cours est important car il pose le socle des connaissances nécessaires pour l’utilisation d’une base de données.

Pour le **cours “Requêtez une base de données avec SQL”**, vous pouvez vous concentrer sur :

- la partie 2 : [Construisez des requêtes SQL simples](https://openclassrooms.com/fr/courses/7818671-requetez-une-base-de-donnees-avec-sql/7883856-affichez-les-donnees-pertinentes-avec-select) ;
- la partie 3 : [Appliquez d’autres fonctionnalités à vos requêtes SQL](https://openclassrooms.com/fr/courses/7818671-requetez-une-base-de-donnees-avec-sql/7884991-agregez-des-lignes-de-donnees-avec-group-by).

Ces deux parties abordent le langage SQL en décrivant l’ensemble des différentes fonctions essentielles.

>[!Note]
>A la fin de ce cours, vous serez en mesure d’**écrire vos requêtes SQL** dans votre base de données.

### Exercice partie 1 - Comprenez des données et créez un schéma relationnel

---

#### Qu’allez-vous faire et comment ?

---

Tout au long de cet exercice en 3 parties, vous serez **Data Engineer** chez **Laplace Immo, un réseau national d’agences immobilières**. Cette entreprise accorde une importance particulière à l’utilisation des données afin de se démarquer de la concurrence.

Vous serez en charge d'un nouveau projet dans lequel vous allez **collecter** l'ensemble des transactions immobilières en France. Cela permettra entre autres de suivre l'évolution du prix au mètre carré et d'identifier les régions où le marché est le plus porteur. Vous utiliserez ensuite cette base pour **analyser** le marché et **répondre aux besoins** de votre entreprise.

L’agence souhaite faire un premier test sous forme d’un **Proof Of Concept (POC)**. Un POC est une version simple du projet, visant à prouver sa faisabilité et sa viabilité avant de procéder à une mise en œuvre complète.

>[!Note]
>À l’issue des 3 parties de cet exercice, vous aurez réalisé deux livrables :
>
>1. **Un dictionnaire des données** complété au format tableur
>2. **Un support de présentation** au format Gslides ou Power Point à l’aide d’un template que nous allons vous fournir contenant :
>     1. le contexte du projet ;
>     2. la transformation des données ;
>     3. un extrait du dictionnaire des données ;
>     4. le schéma relationnel normalisé ;
>     5. une capture d’écran de la base de données avec les tables créées et les données chargées ;
>     6. le code SQL des requêtes et leurs résultats permettant de répondre aux **besoins** de l’agence (qui vous seront présentés à l’étape 2).

#### Prêt à résoudre l’exercice ?

Dans cette première partie, vous allez commencer par **comprendre** les données que vous allez utiliser.

A la fin de cette première partie, vous aurez réalisé :

- le **dictionnaire des données** au format tableur ;
- le **schéma relationnel** de votre future base de données, que vous devrez inclure dans votre support de présentation.

>[!Note]
>Cette première partie est l’étape la plus importante de ce projet, car elle aura des répercussions jusqu’au SQL que vous allez écrire pour extraire vos données.

Pour rappel, avant de commencer votre travail sur ce projet, nous vous conseillons de suivre attentivement le premier cours de [modélisation des bases de données](https://openclassrooms.com/fr/courses/6938711-modelisez-vos-bases-de-donnees).

Nous vous conseillons également de :

- lire l’ensemble du projet (les 3 parties de cet exercice) pour avoir une première vue d’ensemble du projet ;
- prendre des notes sur ce que vous avez compris ou non du projet ;
- réaliser une fiche de synthèse sur ce que vous avez retenu. Cela va vous permettre de renforcer vos connaissances ;
- préparer une liste de questions pour votre session avec votre mentor.

Pour ce faire, vous allez commencer par :

- comprendre [les données](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/Donne%CC%81es-immo+(2).zip) qui sont à votre disposition ;
- compléter le [dictionnaire des données](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/Template_dico_donne%CC%81es+(2)+(1).xlsx) qui constitue votre premier livrable.

Cet exercice est entièrement guidé.

Vous pouvez suivre les étapes ci-dessous.

Lancez-vous dans la première partie de l'exercice !

##### Étapes

<details>
  <summary><strong>Étape 1 - Comprenez les données</strong></summary>

###### Instructions

Pour cette première étape, vous allez vous familiariser avec les données qui sont à votre disposition.

>[!Note]
>Il est particulièrement important de comprendre les **types de données** présentes car cela va **définir les types de variables** que vous allez utiliser dans votre base de données.

Par exemple :

- Si la colonne département est pour vous un **nombre**, alors vous ne pourrez charger que des nombres dans votre base de données.
- Cependant les départements corses s'écrivent souvent 2A et 2B.
- Si vous avez défini la colonne département comme un **nombre** alors toutes les lignes qui contiennent 2A et 2B seront exclues lors de l’importation de vos données.

###### Prérequis

- Avoir suivi le cours sur la modélisation des bases de données.
- Avoir téléchargé les données et le modèle de dictionnaire des données.

###### Résultats attendus

- Une bonne compréhension des types de données présentes dans le fichier.
- Un dictionnaire de données avec les données nécessaires conformément à la [réglementation RGPD](https://www.economie.gouv.fr/entreprises/reglement-general-protection-donnees-rgpd) et respectant la [3ème forme normale](https://openclassrooms.com/fr/courses/6938711-modelisez-vos-bases-de-donnees/7561516-ameliorez-votre-modelisation-grace-aux-formes-normales).

###### Recommandations

>[!Note]
>C’est particulièrement important de prendre du temps pour comprendre les données. Regardez dans chaque colonne les différentes données présentes pour être en mesure de les comprendre.

- Pour chaque variable que vous souhaitez garder, il va falloir remplir les colonnes correspondantes avec :
  - un code
  - une signification
  - un type
  - une longueur
  - une nature
  - une règle de gestion
  - une règle de calcul (si nécessaire)

###### Outils

Pour consulter les données, utilisez soit :

- un tableur : Google Sheet ou Excel. Ce sont les solutions les plus simples.
- un notebook Python si vous êtes à l’aise en programmation.

###### Points de vigilance

>[!Note]
>La compréhension des données est un facteur clé de réussite pour ce projet. Cela va déterminer le degré de complexité du projet dans la création de la base de données, des fichiers à charger ou encore dans les requêtes à écrire.

- Il est également important de bien comprendre les **lois normales** dans les bases de données. Ces lois nous obligent à faire des concessions dans les choix de notre base de données.
- Par exemple, vous souhaitez stocker cette adresse dans une base de données : “2 Cour de l'île Louviers, 75004 Paris”. Pour être conforme à la 1NF (première forme normale), il faut que les données soient **atomiques** (c'est-à-dire qu’elles soient indivisibles sans perdre leur sens).
- Nous aurons donc :
  - Numéro : 2
  - Rue : Cour de l'île Louviers
  - Code postal : 75004
  - Ville : paris

>[!note]
>Nous ne pouvons pas découper la rue (même si elle est composée de plusieurs mots) sans perdre en cohérence dans nos données. L’adresse est donc **atomique** et **conforme à la première forme normale**.

###### Ressource

- [Améliorez votre modélisation grâce aux formes normales - Modélisez vos bases de données](https://openclassrooms.com/fr/courses/6938711-modelisez-vos-bases-de-donnees/7561516-ameliorez-votre-modelisation-grace-aux-formes-normales)

</details>

<details>
  <summary><strong>Étape 2 - Créez le schéma relationnel</strong></summary>

###### Instructions

- Dans cette nouvelle étape, vous allez devoir réaliser le **schéma** de votre base de données. Le plus simple est de repartir du [schéma relationnel existant](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/DAN_V2_P3/Sche%CC%81ma_a%CC%80_comple%CC%80ter.jpg) mais si vous êtes à l’aise, nous vous conseillons de créer votre propre schéma.
- La finalité du projet que vous gérez pour **Laplace Immo** est d’arriver à répondre aux **besoins** en analyse des données de l’entreprise. Quand vous avez pris vos fonctions, vous avez assisté à une réunion au cours de laquelle les besoins en analyse vous ont été exprimés : consultez le [compte-rendu de cette réunion](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/DAN_V2_P3/CR_re%CC%81union.pdf).

###### Prérequis

- Avoir réalisé le dictionnaire des données.
- Être capable d’expliquer la 3ème forme normale.
- Avoir téléchargé l’ébauche du schéma relationnel (si nécessaire).

###### Résultat attendu

- Le schéma relationnel mis à jour avec les informations supplémentaires (ou votre propre schéma réalisé sans l’aide de l’ébauche).

###### Recommandations

- Utilisez l’ébauche du schéma comme base de départ.
- Vous devez être en mesure de **choisir les variables indispensables** pour répondre à l’ensemble des **besoins** de votre entreprise.
  - Par exemple, pour répondre au besoin 2 “Le nombre de ventes d’appartement par région pour le 1er semestre” vous aurez besoin :
    - du nombre de biens vendus ;
    - de la variable Type de bien (pour avoir les appartements) ;
    - de la région ;
    - de la date de vente (pour avoir le 1er semestre).
- Le choix de vos clés primaires et de vos clés étrangères devra être justifié en session bilan, ces notions étant fondamentales pour la cohérence de votre base de données.
- Toutes les données essentielles devront être présentes dans ce nouveau modèle.

###### Outils

- Il existe plusieurs outils pour construire des schémas (SQL Power Architect, Draw.io ou Looping par), mais nous vous conseillons d’utiliser **SQL Power Architect**.
- SQL Power Architect vous permet de **modéliser** votre base de données et de **générer automatiquement le code SQL associé** afin de créer :
  - les tables ;
  - les colonnes ;
  - le paramétrage de votre base de données.

###### Points de vigilance

>[!note]
>Parfois les clés de votre base de données peuvent être une concaténation c'est-à-dire une combinaison de plusieurs chaînes de caractères en une seule des différentes données.

- Dans le cas de ce projet, la clé id_codedep_codecommune “34172” est la concaténation de deux variables (Code département et Code commune).
- Par exemple, pour la commune de Montpellier, nous avons les informations suivantes :
  - Commune : Montpellier
  - Code Département : 34
  - Code commune : 172

La clé 34172 est une clé unique dans la base de données, c’est pour cela que c’est une clé primaire.

###### Ressources

- [SQL Power Architect](https://bestofbi.com/architect-download/)
- [Fiche sur les MPD sur le site base-données.com](https://www.base-de-donnees.com/mpd/)

</details>

<details>
  <summary><strong>Étape 3 - Vérifiez votre travail et faites le point avec votre mentor</strong></summary>

Pour vérifier que vous n’avez rien oublié dans la réalisation de votre exercice, téléchargez et complétez [la fiche d’autoévaluation](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/P3-+DE-+Fiche+d'auto-e%CC%81valuation.pdf).

Parlez-en avec votre mentor durant votre dernière session de mentorat.

</details>

### Exercice partie 2 - Créez une base de données et chargez des données

---

#### Prêt à résoudre l’exercice ?

---

Dans la partie précédente de l’exercice, vous avez étudié les données et préparé le schéma relationnel de la base de données DataImmo.

À la fin de cette deuxième partie, vous aurez achevé :

- la création de la base de données ;
- le chargement des données.

##### Étapes

<details>
  <summary><strong>Étape 1 - Créez la base de données</strong></summary>

###### Prérequis

- Avoir préparé un schéma relationnel de la base de données.

###### Résultats attendus

- Une base de données avec les tables et les colonnes en adéquation avec le schéma relationnel.

###### Recommandations

>[!note]
>Nous vous recommandons de choisir un logiciel de base de données simple pour commencer telle que SQLite studio.

- Le logiciel [SQlite Studio](https://sqlitestudio.pl/) permet de créer une base de données en local et a une interface graphique qui permet de visualiser les tables et les données.
- Si vous êtes à l’aise, vous pouvez vous orienter vers des bases de données plus complexes comme [PostGreSQL](https://www.postgresql.org/) ou [MySQL](https://www.mysql.com/fr/) ou des services de cloud avec des bases de données en ligne gratuites chez AWS avec le service [RDS](https://aws.amazon.com/fr/rds/?did=ft_card&trk=ft_card).
- Si vous avez utilisé SQL Power Architect, le code SQL est automatiquement généré par l’outil.
  - Vous pouvez également créer les tables et les colonnes “à la main” si vous avez une interface graphique.
  - Sinon, vous pouvez écrire vous-même le code SQL qui servira à générer vos tables.

###### Points de vigilance

Soyez sûr à ce niveau du projet, que les CSV chargés contiennent le **même nombre de lignes** que la base de données. Faites le point avec votre mentor si ce n’est pas le cas.

</details>

<details>
  <summary><strong>Étape 2 - Chargez les données dans les base de données</strong></summary>

###### Instructions

Votre base de données est prête, il ne vous reste plus qu'à charger vos données.

Comme vous avez pu le voir dans l’exercice précédent, toutes les données ne sont pas intéressantes et vous ne souhaitez pas tout garder.

Il va vous falloir **préparer des fichiers** tout en respectant les différentes règles :

- L’ordre des colonnes devra être conforme à l'ordre des colonnes dans votre schéma relationnel et également à votre base de données.
- Les différentes formes normales (1er, 2ème et 3ème formes normales)
- L’unicité des différentes clés primaires

Prenons l’exemple du fichier “Référentiel géographique”. Ce fichier contient beaucoup de colonnes redondantes :

- Com_nom_maj_cours : une version en majuscules sans les caractères spéciaux du nom de la commune
- Com_nom_maj : une version en majuscules avec les caractères spéciaux (mais sans accent)
- Com_nom : une version classique du nom de la commune

Il n’y a peut-être pas d'intérêt à garder les trois dans notre base de données mais c’est à vous de faire vos propres choix. Vous avez peut-être décidé de ne garder qu’une version dans votre base de données. Vous préparez donc une nouvelle version de ce fichier conforme à votre base de données.

###### Prérequis

- Avoir une base de données prête (avec les tables et les colonnes).

###### Résultats attendus

- Une base de données opérationnelle avec l’ensemble des données.
- Le respect de l’intégrité de votre base de données vérifié en vous assurant que l’ensemble des données est bien présent.

###### Recommandations

- La préparation des données est une étape importante car il va falloir recréer des nouvelles versions des fichiers conformes à vos tables dans votre base de données.
- Vous devez créer les différents fichiers CSV, en prenant soin d’avoir :
  - des clés primaires dans chaque fichier (vous pouvez tester l’unicité des clés en regardant s’il y a des doublons) ;
  - des [clés étrangères](https://openclassrooms.com/fr/courses/6938711-modelisez-vos-bases-de-donnees/7506536-creez-du-lien-entre-vos-tables-avec-les-cles-etrangeres) pour faire les liens entre les fichiers ;
  - fait attention à la redondance des données : pas de doublon.

>[!note]
>Après le chargement des données, comparez le nombre de lignes de chaque fichier avec le nombre de lignes dans votre base de données. Ce chiffre doit être identique. Attention : le nombre de lignes est toujours égal au **total moins 1** car on ne charge pas les colonnes d'en tête des tableaux.

###### Outils

Le plus simple à cette étape est d’utiliser Google Sheet ou Excel pour préparer les nouveaux fichiers.

###### Points de vigilance

- Si vous constatez que les données dans la base de données ne correspondent pas aux données des fichiers :
  - Vérifiez si les colonnes ne sont pas inversées.
  - La totalité des données n’a pas été chargée ? Vérifiez si les départements de la Corse n'ont pas été exclus à cause du 2A et 2B.
- Pour créer les clés de votre base de données, il y a plusieurs solutions :
  - Auto increment (automatique ou manuel) pour les clés (id_bien et id_vente)
  - Concaténation de plusieurs variables pour id_codedep_codecommune
  - Variable déjà présente que nous transformons en clé avec id_region.

###### Ressources

Consultez la [procédure d'importation et d'exportation de CSV](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/Import+Export+MySQL+PostgreSQL.docx.pdf) pour importer un CSV dans MySQL et PostgreSQL

</details>

<details>
  <summary><strong>Étape 3 - Vérifiez votre travail et faites le point avec votre mentor</strong></summary>

Pour vérifier que vous n’avez rien oublié dans la réalisation de votre exercice, téléchargez et complétez [la fiche d’autoévaluation](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/P3-+DE-+Fiche+d'auto-e%CC%81valuation.pdf).

Parlez-en avec votre mentor durant votre dernière session de mentorat.

</details>

### Exercice partie 3 - Utilisez du SQL pour extraire des données et présentez vos résultats

---

#### Prêt à résoudre l’exercice ?

---

Maintenant que votre base de données est prête et que les données sont chargées, dans cette partie 3 de l'exercice, vous allez vous concentrer sur les derniers éléments devant apparaître dans votre support de présentation :

- le code SQL ;
- l'extraction des données nécessaires à l'aide de requêtes SQL.

Revenons à notre contexte initial. Votre employeur **Laplace Immo**, un réseau national d’agences immobilières, vous a demandé d'analyser le marché et d'aider les différentes agences régionales à mieux accompagner leurs clients.

Vous allez donc devoir répondre aux différents besoins qui sont présents dans le [compte-rendu de réunion](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/DAN_V2_P3/CR_re%CC%81union.pdf) puis préparer un support de présentation à l’aide de ce [modèle](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/804_Data-analyst_V3/804_P5/Pre%CC%81sentation_P5+DA.pptx) pour expliquer les différentes démarches ainsi que vos résultats.

Cet exercice est entièrement guidé.

Vous pouvez suivre les étapes ci-dessous.

##### Étapes

<details>
  <summary><strong>Étape 1 - Créez vos requètes SQL pour extraire des résultats</strong></summary>

Maintenant que votre base de données est créée et chargée avec vos données, vous allez enfin pouvoir passer à la partie **extraction des données** avec du langage SQL.

Vous avez à votre disposition le [compte-rendu de réunion](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/DAN_V2_P3/CR_re%CC%81union.pdf). Pour chaque besoin, vous devrez écrire du code SQL pour extraire les données et fournir les réponses.

###### Prérequis

- Avoir une base de données opérationnelle et chargée avec l’ensemble des données.

###### Résultat attendu

- Un document avec une requête par demande et son résultat.

###### Recommandations

- Relisez bien les différentes questions afin de décomposer les demandes.
- Utilisez dans votre code SQL :
  - des alias pour rendre la lecture plus facile ;
  - des sous-requêtes ou des tables temporaires.
- Sauvegardez systématiquement les requêtes qui fonctionnent et les résultats associés aux requêtes.

###### Points de vigilance

>[!note]
>Lisez les requêtes plusieurs fois et décomposez les demandes. N’allez pas trop vite. Au besoin, faites le point avec votre mentor et demandez-lui de décomposer une requête à haute voix pour vous permettre de comprendre ce qui est attendu.

###### Ressources

Pour connaître les principales commandes SQL, consultez le [site SQL.sh](http://sql.sh/)

</details>

<details>
  <summary><strong>Étape 2 - Préparez votre support de présentation</strong></summary>

Il ne vous reste plus qu'à préparer un support de présentation afin d’expliquer votre **méthodologie** et vos **résultats**.

###### Prérequis

- Avoir terminé l’intégralité des requêtes SQL.

###### Résultat attendu

- Un support de présentation contenant :
  - le contexte du projet ;
  - la transformation des données ;
  - un extrait du dictionnaire des données ;
  - le schéma relationnel normalisé ;
  - une capture d’écran de la base de données avec les tables créées et les données chargées ;
  - le code SQL et le résultat des différentes requêtes permettant de répondre aux questions.

###### Recommandations

- Soyez capable d’expliquer tout le cheminement du projet en commençant par les demandes du projet, en passant par les fichiers Excel, les étapes de création de la base de données et les différents résultats.
- N'oubliez pas que vous êtes un analyste, vous devez donc être capable de commenter les différents résultats des requêtes (vous ne devez pas vous contenter de commenter le code SQL).
- Adaptez votre vocabulaire et votre posture à votre interlocuteur.

###### Outils

- Reprenez le [modèle fourni](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/804_Data-analyst_V3/804_P5/Pre%CC%81sentation_P5+DA.pptx).

</details>

<details>
  <summary><strong>Étape 3 - Vérifiez votre travail et faites le point avec votre mentor</strong></summary>

Pour vérifier que vous n’avez rien oublié dans la réalisation de votre exercice, téléchargez et complétez [la fiche d’autoévaluation](https://s3.eu-west-1.amazonaws.com/course.oc-static.com/projects/922_Data+Engineer/922_P3/P3-+DE-+Fiche+d'auto-e%CC%81valuation.pdf).

Parlez-en avec votre mentor durant votre dernière session de mentorat

</details>

### Livrables et bilan

---

#### Livrables

---

- **Dictionnaire des données** complété au format tableur
- **Support de présentation** au format Gslides ou Power Point contenant au minimum :
  1. le contexte du projet ;
  2. la transformation des données ;
  3. un extrait du dictionnaire des données ;
  4. le schéma relationnel normalisé ;
  5. une capture d’écran de la base de données avec les tables créées et les données chargées ;
  6. le code SQL des requêtes et leurs résultats permettant de répondre aux questions.

>[!note]
>Déposez sur la plateforme, dans un dossier zip nommé **Titre_du_projet_nom_prenom**, tous les livrables du projet comme suit : **Nom_Prenom_n° du livrable_nom du livrable_date de démarrage du projet**.  
Cela donnera :
>
>- *Nom_Prenom_1_dictionnaire_mmaaaa*
>- *Nom_Prenom_2_support_mmaaaa*
>
>Par exemple, le premier livrable peut être :  
*Annonay_Paul-Alexandre_1_dictionnaire_012024*

###### Session de bilan avec votre mentor

---

Pour finaliser ce projet, réservez votre dernière session de mentorat pour effectuer un bilan avec votre mentor sur vos compétences.

Pendant la session, assurez-vous de suivre ces **4 étapes** :

1. Discutez de votre **fiche d'autoévaluation** et des commentaires que vous avez potentiellement laissés dans la colonne "Notes".
2. Expliquez **les difficultés que vous avez rencontrées** et ce qui a été plus difficile. Cela vous servira à mieux les aborder dans vos futurs projets.
3. Présentez **vos points forts**, ce que vous avez particulièrement apprécié accomplir et pourquoi ces tâches vous ont paru plus faciles. Réalisez une **démonstration en direct** de vos requêtes SQL.
4. Identifiez les **actions à mener** par la suite : quel cours devez-vous revoir, quels sont les éléments à approfondir et sur lesquels vous devez rester vigilant.
