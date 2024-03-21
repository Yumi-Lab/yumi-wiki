git clone https://github.com/Yumi-Lab/yumi-wiki.git

# Entrer dans le répertoire du dépôt
cd yumi-wiki

# Configurer l'environnement virtuel
python3 -m venv venv

# Activer l'environnement virtuel
source venv/bin/activate

# Installer MkDocs et MkDocs Material
pip install mkdocs mkdocs-material

# Construire le site avec MkDocs
mkdocs build

# Copier le dossier /img dans /site (ajustez le chemin de /img si nécessaire)
cp -r img site/

# Désactiver l'environnement virtuel
deactivate

# Retourner au répertoire parent
cd ../

# Vérifier si le dossier existe dans le répertoire cible et le supprimer si néc>
if [ -d "/var/www/html/yumi/yumi-wiki" ]; then
    sudo rm -r /var/www/html/yumi/yumi-wiki
fi

# Déplacer le dossier du projet vers le répertoire cible
sudo mv yumi-wiki /var/www/html/yumi/yumi-wiki

echo "Déploiement de yumi-wiki terminé."

