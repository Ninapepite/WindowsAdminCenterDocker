# Windows Admin Center Docker

C'est deux images permettent de déployer Windows Admin Center dans un conteneur.

La version placée dans le dossier **'Dev'** permet de lancer WaC en peu de temps mais vous ne pouvez pas garder votre configuration au redémarrage du conteneur.

La version placée dans le dossier **'Stable'** permet de déployer WaC en hébergeant votre configuration dans vos volumes sur l'hôte.

Pour plus d'informations sur chaque version merci de vous référer aux releases.

## Construire l'image

### Version dev

[Release](https://github.com/Ninapepite/WindowsAdminCenterDocker/releases/tag/Dev)

 ```docker build -t  ninapepite/windowsadmincenter:dev .```
 
 ### Version stable
 
 [Release](https://github.com/Ninapepite/WindowsAdminCenterDocker/releases/tag/Stable)
 
  ```docker build -t  ninapepite/windowsadmincenter .```
 
Ces images ont étaient construites depuis l'image mcr.microsoft.com/windows/servercore:ltsc2019.
Vous pouvez à tout moment les modifier avec les commandes de l'image parente.

## Variables disponibles

Les deux variables suivantes sont nécessaires au lancement du conteneur. 

Elles permettent de créer un compte Administrateur.

```wacuser = user```


```wacpassword = password```

 ## Exemples d'utilisation
 
 ### Version dev
 
 ```docker run -d -p 443:443 -e wacuser=Admin1 -e wacpassword="P@$$word" ninapepite/windowsadmincenter:dev ```
 
 Rendez-vous sur https://localhost:443 pour accéder à votre conteneur avec vos identifiants.
 
 ### Version stable
 
Executer la commande docker run avec Powershell pour faciliter la gestion des volumes.

Le volume 'Config' stock les fichiers de l'interface web et des modules.
 
Le volume 'Data' stock les fichiers du programme.
 
 ```docker run -it -p 443:443 -v c:\config:"C:\ProgramData\Server Management Experience" wacuser=Admin1 -e wacpassword="P@$$word" -v c:\data:c:\WaC ninapepite/windowsadmincenter```


 ```docker run -d -p 443:443 -v c:\config:"C:\ProgramData\Server Management Experience" wacuser=Admin1 -e wacpassword="P@$$word" -v c:\data:c:\WaC --restart unless-stopped --name wac ninapepite/windowsadmincenter```


 Rendez-vous sur https://localhost:443 pour accéder à votre conteneur avec vos identifiants.
 
 ## Fonctionnalités en cours de développement 
 
- Gestion du port interne 
- Gestion du certificat ssl
- [Prise en charge du scénario gMSAs](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/manage-serviceaccounts)
