# Windows Admin Center Docker

Ce conteneur permet de tester Windows Admin Center en quelques minutes. On peut ajouter des extensions, se connecter à des serveurs avec le compte local ou celui de votre domaine.

# Docker Hub

https://hub.docker.com/r/ninapepite/windowsadmincenter

# Construire l'image

 ```docker build -t  ninapepite/windowsadmincenter .```
 
Cette image a été construite depuis l'image mcr.microsoft.com/windows/servercore:ltsc2019.

Vous pouvez à tout moment modifier l'image avec les commandes de l'image parente.

# Variables disponibles

Avec les deux variables suivante vous pouvez créer un compte administrateur.

wacuser = user


wacpassword = password

 ```docker run -d -p 443:443 -e wacuser=Ninapepite -e wacpassword=Azerty123@ ninapepite/windowsadmincenter ```
 
 Rendez-vous sur https://localhost:443 pour accéder à votre conteneur avec vos identifiants.

