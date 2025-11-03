# **PHASE 1 — LES FONDATIONS DU CI/CD** [[1]](#ref1)

## **Comprendre et visualiser le concept**

------

### **1. Qu’est-ce que CI/CD ?**

**CI/CD** = *Continuous Integration / Continuous Delivery (ou Deployment)*.
 C’est une **philosophie d’automatisation du cycle de développement logiciel**.

#### **1.1. Continuous Integration (CI)**

> “Chaque fois qu’un développeur pousse du code, il est automatiquement testé et validé.”

L’idée :

- Tu ne veux plus attendre la fin du projet pour tester ton code.
- Chaque *commit* déclenche un processus automatique :
  - Télécharger le code.
  - Installer les dépendances.
  - Lancer les tests.
  - Analyser la qualité du code.

**Objectif :** détecter les erreurs immédiatement.

**Exemple concret** :

> Imagine 5 développeurs qui bossent sur un site e-commerce.
>  Sans CI, ils découvrent que leurs changements cassent la page panier **3 jours plus tard**.
>  Avec CI, GitHub Actions lance les tests **à chaque push** et signale immédiatement l’erreur.

------

#### **1.2. Continuous Delivery (CD)**

> “Le code testé est automatiquement préparé pour être déployé.”

- À chaque validation (tests réussis), le code est **packagé** :
  - Création d’une image Docker, d’un fichier .zip ou .jar.
  - Stockage dans un registre (DockerHub, GitHub Packages…).
- Le déploiement n’est pas encore automatique, il faut une validation humaine.

------

#### **1.3. Continuous Deployment**

> “Le code validé est automatiquement déployé sur un serveur ou un cloud.”

Ici, plus besoin de cliquer sur quoi que ce soit :

- GitHub Actions → Build → Test → Push → Deploy automatique sur Render, AWS, etc.

------

### **2. Le pipeline logiciel**

#### **2.1 Outils et écosystème**

- Git et GitHub (ou GitLab)
- Docker (fondamental pour le packaging)
- **Serveurs CI/CD** : GitHub Actions, Jenkins, GitLab CI, CircleCI
- **Cloud providers** : AWS, Azure, ou Render/Heroku pour commencer

Voici une représentation du pipeline CI/CD :

```basic
Développeur → git add . → git commit -m "Un message" → git push
    ↓
[Pipeline CI]
    - Build du code
    - Tests unitaires
    - Analyse qualité
    ↓
[Pipeline CD]
    - Build Docker image
    - Push image sur DockerHub
    - Déploiement sur le serveur
    ↓
Application en ligne
```

------



## **Mise en pratique - Premier microservice + workflow Git**

On va passer au **projet pratique** : ton premier microservice Python avec Flask.

------

### **3. Projet pratique : Hello Microservice**

#### **Objectif**

Créer une API Flask minimaliste et la déployer manuellement.
Tu comprendras le flux : **Git → add → commit → push → déploiement manuel.**

------

### **Étape 1 : Préparer ton environnement**

**Pré-requis :**

- Python 3.x installé
- Git installé
- Un compte GitHub créé

**Vérifie les installations :**

```bash
python --version
git --version
```

------

### **Étape 2 : Créer le projet localement**

Crée un dossier :

```bash
mkdir hello-ci-cd && cd hello-ci-cd
```

Initialise Git :

```bash
git init
```

Crée ton environnement virtuel :

```bash
python -m venv venv
source venv/bin/activate   # macOS/Linux
venv\Scripts\activate      # Windows
```

Installe Flask :

```bash
pip install --upgrade pip && pip install flask gunicorn
pip freeze > requirements.txt
```

------



### **Étape 3 : Créer ton microservice**

Crée le fichier `app/app.py` :

```python
from flask import Flask

app = Flask(__name__)

@app.route("/hello")
def hello():
    return {"message": "Hello World from CI/CD!"}

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5801)
```

Teste localement :

```bash
gunicorn app.app:app
```

Dans ton navigateur :
 👉 http://localhost:5801/hello

Tu devrais voir :

```json
{"message": "Hello World from CI/CD!"}
```

------

### **Étape 4 : Versionner ton code sur GitHub**

Crée un dépôt vide sur GitHub appelé `hello-ci-cd`.

Dans ton terminal :

```bash
git add .
git commit -m "Initial commit: Flask hello microservice"
git branch -M main
git remote add origin https://github.com/<ton_username>/hello-ci-cd.git
git push -u origin main
```

------

### **Étape 5 : Déploiement manuel (premier pas vers le CD)**

On ne fait pas encore d’automatisation : tu vas juste lancer l’app sur un petit cloud gratuit.
Choisis l’un de ces trois :

1. **Render** (simple, gratuit, YAML friendly)
2. **Railway.app** (super intuitif)
3. **Heroku** (un peu moins gratuit, mais très formateur)

Exemple avec **Render** :

- Va sur [https://render.com](https://render.com/)

- Connecte ton GitHub

- Clique sur “New → Web Service”

- Sélectionne ton repo `hello-ci-cd`

- Commande de démarrage :

  ```
  gunicorn app.app:app
  ```

- Port : `5801`

- Clique sur “Deploy” 

Tu viens de **faire ton premier déploiement manuel**, la base du “D” dans CI/CD.

### **Étape 5 : Tester**

Va sur https://hello-ci-cd-xxxx.onrender.com/hello

xxxx est fournie par render

Tu devrais voir :

```json
{"message": "Hello World from CI/CD!"}
```

------

### **Étape 6 : Visualise ton premier pipeline (mentalement)**

Tu as fait : **Code →** **Test local** → **Commit →** **Push →** **Déploiement (manuel)** → **Accéder au service**

Tu as donc déjà **le squelette du pipeline**.

------

### **Étape 7 : Bonus, Préparer le Dockerfile**

Même si tu ne l’utilises pas encore, prépare ton Dockerfile (il servira en Phase 2) :

Crée un fichier `Dockerfile` :

```Dockerfile
# Étape 1 : Image de base
FROM python:3.10-slim

# Étape 2 : Dossier de travail
WORKDIR /app

# Étape 3 : Copier les fichiers
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Étape 4 : Copier le reste du code
COPY . .

# Étape 5 : Lancer l'application
ENTRYPOINT ["python"]
CMD ["app/app.py"]
```

Teste ton build :

```bash
docker build -t hello-ci-cd .
docker run -d -p 5801:5801 --name hello hello-ci-cd
```

------

Vérifie : 

```basic
>> docker ps
CONTAINER ID   IMAGE         COMMAND               CREATED          STATUS          PORTS                                         NAMES
051d7ccde480   hello-ci-cd   "python app/app.py"   20 seconds ago   Up 20 seconds   0.0.0.0:5801->5801/tcp, [::]:5801->5801/tcp   hello
```

Va sur  👉 http://localhost:5801/hello

Tu devrais voir :

```json
{"message": "Hello World from CI/CD!"}
```

### **Fait :**

✅ Le concept CI/CD et son intérêt

✅ Le pipeline logique d’un projet moderne

✅ Git et GitHub en pratique

✅ La création et le déploiement manuel sur render d’un microservice Flask

✅ Les bases de Docker pour la suite



# RÉFÉRENCES

[<a id="ref1">1</a>] [PHASE 1](https://github.com/Bamolitho/hello-ci-cd)  

[<a id="ref2">2</a>] [Texte a afficher_][Lien]
