# Makefile - Flask Hello Microservice

.PHONY: venv-setup venv-activate install run github github-msg clean clean-pyc help

# Créer un venv, installer flask et générer requirements.txt
venv-setup:
	python -m venv venv
	bash -c "source venv/bin/activate && pip install --upgrade pip && pip install flask && pip freeze > requirements.txt"

# Activer le venv (instruction pour l'utilisateur)
venv-activate:
	@echo "Pour activer le venv, exécutez:"
	@echo "source venv/bin/activate"

# Installer les dépendances depuis requirements.txt
install:
	bash -c "source venv/bin/activate && pip install -r requirements.txt"

# Lancer l'application Flask
run:
	bash -c "source venv/bin/activate && python app.py"

# Pousser sur github
github:
	git add .
	git commit -m "Initial commit: Flask hello microservice"
	git push

# Pousser avec message personnalisé
github-msg:
	@read -p "Message de commit: " msg; \
	git add .; \
	git commit -m "$$msg"; \
	git push

# Nettoyer le venv
clean:
	rm -rf venv
	rm -f requirements.txt

# Nettoyer les fichiers Python
clean-pyc:
	find . -type f -name '*.pyc' -delete
	find . -type d -name '__pycache__' -delete

# Afficher l'aide
help:
	@echo "Commandes disponibles:"
	@echo "  make venv-setup      - Créer venv et installer Flask"
	@echo "  make venv-activate   - Instructions pour activer venv"
	@echo "  make install         - Installer dépendances"
	@echo "  make run             - Lancer l'application"
	@echo "  make github          - Push vers GitHub"
	@echo "  make github-msg      - Push avec message personnalisé"
	@echo "  make clean           - Supprimer venv"
	@echo "  make clean-pyc       - Nettoyer fichiers Python"