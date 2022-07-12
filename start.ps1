#Ajout d'arguments au script pour transporter les variables du dockerfile
param(

    [Parameter(Mandatory = $true)]
    [string]$wac_user,

    [Parameter(Mandatory = $true)]
    [string]$wac_password
)
#Déclaration de variable qui lit le fichier log de l'installation
$log_install = get-content "c:\log.txt"
#Affiche les logs
Write-Verbose "$log_install"
#Ajout de l'utilisateur avec les variables récupérés du dockerfile
.\users -username $wac_user -password $wac_password -Verbose
#Variable de temps
$lastCheck = (Get-Date).AddSeconds(-2)
#Check up continue des évenements de Windows Admin Center
while ($true) {
    Get-EventLog -LogName Microsoft-ServerManagementExperience -After $lastCheck | Select-Object TimeGenerated, EntryType, Message
    $lastCheck = Get-Date
    Start-Sleep -Seconds 2
}
