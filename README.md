# Windows Admin Center Docker

Ce conteneur permet de tester Windows Admin Center en quelques minutes. On peut ajouter des extensions, se connecter à des serveurs avec le compte local ou du domaine.

# Construire l'image

 ```docker build -t  Ninapepite/WindowsAdminCenter .```
 
Ce conteneur a été construit avec l'image mcr.microsoft.com/windows/servercore:ltsc2019.

Vous pouvez à tout moment modifier l'image avec les commandes de l'image parent.

# Variables disponible

Avec les deux variables suivante vous pouvez créer un utiisateurs administrateur.

wacuser = user


wacpassword = password

 ```docker run -d -p 443:443 -e wacuser=Ninapepite -e wacpassword=Azerty123@ Ninapepite/WindowsAdminCenter ```
 
 Rendez-vous sur https://localhost:443 pour acceder à votre conteneur.
