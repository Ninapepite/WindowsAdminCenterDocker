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
#Téléchargement de Windows Admin Center et installation
RUN powershell.exe -command \
    Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/p/?linkid=2194936' -OutFile 'c:\wac.msi' ; \
    Start-Process c:\wac.msi -ArgumentList '/qn /L*v c:\log.txt SME_PORT=443 SSL_CERTIFICATE_OPTION=generate TRANSFORMS=wac-install.mst' -Wait ; \
    Remove-Item -Force 'c:\wac.msi'
#Prise en charge des certificats X.509
RUN .\activetls.ps1
#Vérification que WaC répond
HEALTHCHECK --interval=5s \
 CMD powershell -command try { $response = iwr https://localhost:443 -UseBasicParsing -UseDefaultCredentials; \
     if ($response.StatusCode -eq 200) { return 0} else {return 1}; \
    } catch { return 1 }
#Entrée du conteneur
CMD .\start -wac_user $env:wacuser -wac_password $env:wacpassword -Verbose
#Exposition du port 443
EXPOSE 443
