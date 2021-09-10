[comment]: <> (- to run pytest: pip install six)

[comment]: <> (- Correct Readme for sqlite3 commands)

[comment]: <> (- flake8)
## Résumé

Site web d'Orange County Lettings

## Développement local

### Prérequis

- Compte GitHub avec accès en lecture à ce repository
- Git CLI
- SQLite3 CLI
- Interpréteur Python, version 3.6 ou supérieure

Dans le reste de la documentation sur le développement local, il est supposé que la commande `python` de votre OS shell exécute l'interpréteur Python ci-dessus (à moins qu'un environnement virtuel ne soit activé).

### macOS / Linux

#### Cloner le repository

- `cd /path/to/put/project/in`
- `git clone https://github.com/OpenClassrooms-Student-Center/Python-OC-Lettings-FR.git`

#### Créer l'environnement virtuel

- `cd /path/to/Python-OC-Lettings-FR`
- `python -m venv venv`
- `apt-get install python3-venv` (Si l'étape précédente comporte des erreurs avec un paquet non trouvé sur Ubuntu)
- Activer l'environnement `source venv/bin/activate`
- Confirmer que la commande `python` exécute l'interpréteur Python dans l'environnement virtuel
`which python`
- Confirmer que la version de l'interpréteur Python est la version 3.6 ou supérieure `python --version`
- Confirmer que la commande `pip` exécute l'exécutable pip dans l'environnement virtuel, `which pip`
- Pour désactiver l'environnement, `deactivate`

#### Exécuter le site

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `pip install --requirement requirements.txt`
- `python manage.py runserver`
- Aller sur `http://localhost:8000` dans un navigateur.
- Confirmer que le site fonctionne et qu'il est possible de naviguer (vous devriez voir plusieurs profils et locations).

#### Linting

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `flake8`

#### Tests unitaires

- `cd /path/to/Python-OC-Lettings-FR`
- `source venv/bin/activate`
- `pytest`

#### Base de données
* Avant de refactorer le code
  - `cd /path/to/Python-OC-Lettings-FR`
  - Ouvrir une session shell `sqlite3`
  - Se connecter à la base de données `.open oc-lettings-site.sqlite3`
  - Afficher les tables dans la base de données `.tables`
  - Afficher les colonnes dans le tableau des profils, `pragma table_info(oc_lettings_site_profile);`
  - Lancer une requête sur la table des profils, `select user_id, favorite_city from oc_lettings_site_profile where favorite_city like 'B%';`
  - `.quit` pour quitter
  
* Refactorer le codes:
  - `cd /path/to/Python-OC-Lettings-FR`
  - Préserver la base de données `cp oc-lettings-site.sqlite3 oc-lettings-site-old.sqlite3 `
  - Créer deux applications : lettings et profiles puis refactorer le code de oc_lettings_site à ces deux apps.
  - Dans setting.py, ajouter dans INSTALLED_APPS ces deux apps: 'lettings' et 'profiles'
  - Créer un nouveau dossier "core" et déplacer les fichiers: asgi.py, settings.py  urls.py  wsgi.py depuis
  oc_lettings_site (faire les modifications nécessaires, par exemple, remplacer "oc_lettings_site" par "core" dans quelque terms.)
  - Transformer oc_lettings_site en une application: ajouter "oc_lettings_site" dans INSTALLED_APPS de setting.py
* Après d'avoir refactoré le code, copier les données :
  * Méthode 1:
    - Préserver la base de données cp oc-lettings-site.sqlite3 oc-lettings-site-old.sqlite3 
    - Lancer `python manage.py makemigrations` puis `python manage.py migrate` 
    - Une nouvelle base de données crée sous le nom: `oc-lettings-site.sqlite3`

    - Ouvrir une session shell `sqlite3`
    - Effectuer les commands suivants pour copier les tables de l'ancienne db à la nouvelle db :
    ```
    .open oc-lettings-site-old.sqlite3
    ATTACH DATABASE 'oc-lettings-site.sqlite3' AS new_db;
    INSERT INTO new_db.lettings_letting SELECT * FROM oc_lettings_site_letting;
    INSERT INTO new_db.lettings_address SELECT * FROM oc_lettings_site_address;
    INSERT INTO new_db.profiles_profile SELECT * FROM oc_lettings_site_profile;
    ```
  * Méthode 2:
    - Laisser Django générer les changements en lançant `python manage.py makemigrations`
    - Les migrations sont créées, dans ce cas : lettings/migrations/0001_initial.py, 
    profiles/migrations/0001_initial.py et oc_lettings_site/migrations/0003_auto_20210815_1634.py
    - Pour obtenir le nom du modèle de Profile dans l'application du profiles, générez le SQL pour la migration qui crée le Profile :
    `python manage.py sqlmigrate profiles 0001`
    - Idem pour les modèles Address et Letting dans lettings: `python manage.py sqlmigrate lettings 0001`
    - Pour réutiliser la base de données origine (oc-lettings-site-hieu.sqlite3), changer manuellement les fichiers : lettings/migrations/0001_initial.py, 
    profiles/migrations/0001_initial.py et oc_lettings_site/migrations/0003_auto_20210815_1634.py (voir le détail dans ces fichiers). 
    Un point commun, c'est de remplacer les migrations générées automatiques migrations.XXX() par migrations.SeparateDatabaseAndState()
    - Puis lancer `python manage.py migrate` 
    

#### Panel d'administration

- Aller sur `http://localhost:8000/admin`
- Connectez-vous avec l'utilisateur `admin`, mot de passe `Abc1234!`

### Windows

Utilisation de PowerShell, comme ci-dessus sauf :

- Pour activer l'environnement virtuel, `.\venv\Scripts\Activate.ps1` 
- Remplacer `which <my-command>` par `(Get-Command <my-command>).Path`

## Déploiement
### Condition 
Il faut avoir un compte pour :

- Github
- CircleCI
- Dockerhub
- Heroku
- Sentry

Ici, le compte de CircleCI connecte avec le compte de Github et détecte automatiquement 
un nouveau projet poussé sur Github. Si un projet sur Github est choisi de suivre dans CircleCI, 
chaque nouvelle version déclenche les flux de travail (workflows) défini dans le fichier config.yml.

### Mise en place
Pour un projet suivi par CircleCI, les variables sensibles et les données d'authentication des comptes 
(ici, Dockerhub, Heroku, Sentry) sont nécessaire de paramétrer/cacher via Environment Variables du projet.

Dans CircleCI, allez dans le projet, choisissez Project Settings > Environment Variables > 
Add Environment Variable. Pour ce projet, les paramètres suivants sont mis dans Environment Variables:

- DSN_SENTRY (c'est la valeur de dsn d'un projet créé dans Sentry).
- SECRET_KEY (c'est la valeur de SECRET_KEY dans settings.py du projet).
- DOCKERHUB_USERNAME (c'est l'username d'un compte Dockerhub).
- DOCKERHUB_PASSWORD (c'est le Token Access du compte Dockerhub).
- HEROKU_API_KEY (c'est le API Key du compte Heroku - voir dans Account Settings > API Key).
- HEROKU_APP_NAME (c'est le nom d'une application créée dans Heroku - il faut la créer avant le déploiement).

### Note sur l'image Docker
Dans ce projet, l'image Docker est créée à partir de la branche "main" du projet sur Github. 
L'image est poussée sur Dockerhub. Pour lancer cette image localement, la cloner depuis Dockerhub et
la lancer localement.

Exemple des commandes :
```
docker pull votre_username_dockerhub/oc-lettings-site:tag_image
docker run --rm --publish 8000:8000 votre_username_dockerhub/oc-lettings-site:tag_image python manage.py runserver 0.0.0.0:8000
```
Puis aller dans "localhost:8000" pour naviguer l'application.

Pour voir le résultat du flake 8 ou les tests :
```
docker run votre_username_dockerhub/oc-lettings-site:tag_image flake8
docker run votre_username_dockerhub/oc-lettings-site:tag_image pytest
```