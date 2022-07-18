#On choisit une version de windows server
FROM mcr.microsoft.com/windows/servercore:ltsc2019
#Déclaration des variables pour l'ajout d'un compte administrateur
ENV wacuser="_" \
    wacpassword="_"
#Déclaration du shell utilisé
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
#Copie du fichier de configuration de Windows Admin Center
COPY *.mst /
#Copie des scripts powershell
COPY *.ps1 /
#Déclaration du chemin d'entrée
WORKDIR /
#Entrée du conteneur
CMD .\start -wac_user $env:wacuser -wac_password $env:wacpassword -Verbose
#Exposition du port 443
EXPOSE 443
