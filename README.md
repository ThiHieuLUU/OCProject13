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
* Avant de refactorer le codes
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
  - Lancer `python manage.py makemigrations` puis `python manage.py migrate` 
  - Une nouvelle base de données crée sous le nom: `oc-lettings-site.sqlite3`
* Après d'avoir refactoré le code, copier les données:
  - Ouvrir une session shell `sqlite3`
  - Effecter les commands suivants pour copier les tables de l'ancienne db à la nouvelle db :
  ```
  .open oc-lettings-site-old.sqlite3
  ATTACH DATABASE 'oc-lettings-site.sqlite3' AS new_db;
  INSERT INTO new_db.lettings_letting SELECT * FROM oc_lettings_site_letting;
  INSERT INTO new_db.lettings_address SELECT * FROM oc_lettings_site_address;
  INSERT INTO new_db.profiles_profile SELECT * FROM oc_lettings_site_profile;
  ```
    
    

#### Panel d'administration

- Aller sur `http://localhost:8000/admin`
- Connectez-vous avec l'utilisateur `admin`, mot de passe `Abc1234!`

### Windows

Utilisation de PowerShell, comme ci-dessus sauf :

- Pour activer l'environnement virtuel, `.\venv\Scripts\Activate.ps1` 
- Remplacer `which <my-command>` par `(Get-Command <my-command>).Path`
