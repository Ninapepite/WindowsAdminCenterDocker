# Windows Admin Center Docker

Ce conteneur permet de tester Windows Admin Center en quelques minutes. On peut ajouter des extensions, se connecter à des serveurs avec le compte local ou celui de votre domaine.

# Construire l'image

 ```docker build -t  Ninapepite/WindowsAdminCenter .```
 
Cette image a été construit depuis l'image mcr.microsoft.com/windows/servercore:ltsc2019.

Vous pouvez à tout moment modifier l'image avec les commandes de l'image parente.

# Variables disponible

Avec les deux variables suivante vous pouvez créer un utilisateur administrateur.

wacuser = user


wacpassword = password

 ```docker run -d -p 443:443 -e wacuser=Ninapepite -e wacpassword=Azerty123@ ninapepite/windowsadmincenter ```
 
 Rendez-vous sur https://localhost:443 pour acceder à votre conteneur avec vos identifiants.

