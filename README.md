# Windows Admin Center Docker

C'est deux images permettent de déployer Windows Admin Center dans un conteneur.

La version placée dans le dossier Dev permet de lancer WaC en peu de temps mais vous ne pouvez pas garder votre configuration au redémarrage du conteneur

La version placée dans le dossier persistant vous permet de déployer WaC en hébergant votre configuration dans vos volumes sur l'hôte.

# Construire l'image

Pour l'image dev :

 ```docker build -t  ninapepite/windowsadmincenter-dev .```
 
 Pour l'image persistant :
 
  ```docker build -t  ninapepite/windowsadmincenter .```
 
Ces images ont étaient construites depuis l'image mcr.microsoft.com/windows/servercore:ltsc2019.
Vous pouvez à tout moment les modifier avec les commandes de l'image parente.

# Variables disponibles

Avec les deux variables suivantes vous pouvez créer un compte administrateur.

wacuser = user


wacpassword = password

 # Exemple d'utilisation
 
 Version dev :
 
 ```docker run -d -p 443:443 -e wacuser=Ninapepite -e wacpassword=Azerty123@ ninapepite/windowsadmincenter ```
 
 Rendez-vous sur https://localhost:443 pour accéder à votre conteneur avec vos identifiants.
 
 Version persistant :
 
 ```docker run -it --dns 192.168.1.10 -p 443:443 -v c:\config:"C:\ProgramData\Server Management Experience" -e wacuser=Ninapepite -e wacpassword=Azerty123@ -v c:\data:c:\WaC ninapepite/windowsadmincenter```


 ```docker run -d --dns 192.168.1.10 -p 443:443 -v c:\config:"C:\ProgramData\Server Management Experience" -e wacuser=Ninapepite -e wacpassword=Azerty123@ -v c:\data:c:\WaC --restart unless-stopped ninapepite/windowsadmincenter```

