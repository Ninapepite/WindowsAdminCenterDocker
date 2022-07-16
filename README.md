# Windows Admin Center Docker

Ce conteneur permet de déployer Windows Admin Center en quelques minutes.

Cette version de WaC à les mêmes fonction que la version Windows Server classic.

Vous pouvez ajouter des machines par le noms ou l'ip et vous connecter avec un compte local ou celui de votre domaine.


# Docker Hub

https://hub.docker.com/r/ninapepite/windowsadmincenter

# Construire l'image

 ```docker build -t  ninapepite/windowsadmincenter .```
 
Cette image a été construite depuis l'image mcr.microsoft.com/windows/servercore:ltsc2019.

Vous pouvez à tout moment la modifier avec les commandes de l'image parente.

# Variables disponibles

Avec les deux variables suivantes vous pouvez créer un compte administrateur.

wacuser = user


wacpassword = password

 # Exemple d'utilisation
 
 ```docker run -d -p 443:443 -e wacuser=Ninapepite -e wacpassword=Azerty123@ ninapepite/windowsadmincenter ```
 
 Rendez-vous sur https://localhost:443 pour accéder à votre conteneur avec vos identifiants.

