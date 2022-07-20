#Ajout d'arguments au script pour transporter les variables du dockerfile
param(

    [Parameter(Mandatory = $true)]
    [string]$wac_user,

    [Parameter(Mandatory = $true)]
    [string]$wac_password
)
#Mise en place d'un mot de passe pour sauvegarder le certificat
$certpass = ConvertTo-SecureString -String "Certpass" -Force -AsPlainText
#Création de paramètres pour la création de service
$Gatewaysvc = @{
    Name = "ServerManagementGateway"
    BinaryPathName = '"C:\WaC\sme.exe"'
    DependsOn = "WinRM"
    DisplayName = "Service Windows Admin Center"
    StartupType = "Automatic"
    Description = "Service de serveur web de Windows Admin Center."
}
$Accountsvc = @{
    Name = "ServerManagementGatewayAccount"
    BinaryPathName = '"C:\WaC\sme.exe"'
    DisplayName = "Service de compte Windows Admin Center"
    StartupType = "Manual"
    Description = "Gérer le compte d'usurpation d'identité demandé par le service Windows Admin Center."
}
#Déclaration d'une fonction qui permet de vérifier les logs de windows admin center
function Checkup {
    while ($true)
    {
        Get-EventLog -LogName Microsoft-ServerManagementExperience -After $CheckPoint | Select-Object TimeGenerated, EntryType, Message
        $CheckPoint = Get-Date
        Start-Sleep -Seconds 2
    }
}
#Ajout de l'utilisateur
.\users -username $wac_user -password $wac_password -Verbose
#Variable pour vérifier le dossier de l'installation
$CheckInstall = Get-ChildItem C:\WaC
#Si aucun fichier n'es présent dans le dossier d'installation de windows admin center
if ($CheckInstall.Count -eq "0")
{
    #Téléchargement de WaC
    Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/p/?linkid=2194936' -OutFile 'c:\wac.msi'
    #Installation
    Start-Process c:\wac.msi -ArgumentList '/qn /L*v c:\log.txt SME_PORT=443 SSL_CERTIFICATE_OPTION=generate TRANSFORMS=wac-install.mst INSTALLFOLDER=C:\WaC' -Wait
    #Cleanup des fichiers
    Remove-Item -Force 'c:\wac.msi'
    Remove-Item -Force 'c:\wac-install.mst'
    #Récupération de l'empreinte du certificat
    $ListCrt = Get-ChildItem 'Cert:\LocalMachine\My\'
    $Thumb = $ListCrt.Thumbprint
    #Exportation du certificat et sauvegarde dans le dossier data
    Get-childItem -Path cert:\localMachine\my\$Thumb | Export-PfxCertificate -FilePath C:\WaC\wac.pfx -Password $certpass
    #Export et sauvegarde dans data des clé de registre
    reg export HKLM\SOFTWARE\Microsoft\ServerManagementGateway c:\WaC\software.reg
    reg export HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Microsoft-ServerManagementExperience\ c:\WaC\log.reg
    #Affiche les logs
    $log_install = get-content "c:\log.txt"
    Write-Verbose "$log_install"
    Remove-Item -Force 'c:\log.txt'
    $CheckPoint = (Get-Date).AddSeconds(-2)
    #Check up continue des évenements de Windows Admin Center
    Checkup

}
else
{
    $ServiceState = Get-Service -Name ServerManagementGateway -ErrorAction SilentlyContinue
    if ($ServiceState -eq $NULL) {
        New-Service @Gatewaysvc
        New-Service @Accountsvc
        Reg import c:\wac\software.reg
        Reg import c:\wac\log.reg
        Start-Service -Name ServerManagementGateway
        Import-PfxCertificate -FilePath C:\WaC\wac.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $certpass -Exportable
        $ListCrt = Get-ChildItem 'Cert:\LocalMachine\My\'
        $Thumb = $ListCrt.Thumbprint
        netsh http add sslcert ipport=0.0.0.0:443 certhash=$Thumb appid="{98a42deb-1a89-4759-ab35-190796e9985a}"
        Restart-Service -Name ServerManagementGateway
        $CheckPoint = (Get-Date).AddSeconds(-2)
        #Check up continue des évenements de Windows Admin Center
        Checkup
    }
    else {
        #Importation des clé
        Reg import c:\wac\software.reg
        Reg import c:\wac\log.reg
        #Démarrage du service
        Start-Service -Name ServerManagementGateway
        #Importation du certificat
        Import-PfxCertificate -FilePath C:\WaC\wac.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $certpass -Exportable
        #Récupération de l'empreinte du certificat
        $ListCrt = Get-ChildItem 'Cert:\LocalMachine\My\'
        $Thumb = $ListCrt.Thumbprint
        #Ecoute du port 443 avec le certificat importé
        netsh http add sslcert ipport=0.0.0.0:443 certhash=$Thumb appid="{98a42deb-1a89-4759-ab35-190796e9985a}"
        #Redémarrage du service
        Restart-Service -Name ServerManagementGateway
        $CheckPoint = (Get-Date).AddSeconds(-2)
        #Check up continue des évenements de Windows Admin Center
        Checkup
    }
}
