#Ajout d'arguments au script pour transporter les variables du dockerfile
param(

    [Parameter(Mandatory = $true)]
    [string]$wac_user,

    [Parameter(Mandatory = $true)]
    [string]$wac_password
)
$certpass = ConvertTo-SecureString -String "Certpass" -Force -AsPlainText
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
function Checkup {
    while ($true)
    {
        Get-EventLog -LogName Microsoft-ServerManagementExperience -After $CheckPoint | Select-Object TimeGenerated, EntryType, Message
        $CheckPoint = Get-Date
        Start-Sleep -Seconds 2
    }
}
#$Monitor = {
#    $CheckPoint = (Get-Date).AddSeconds(-2)
    #Check up continue des évenements de Windows Admin Center
#    while ($true)
#    {
#        Get-EventLog -LogName Microsoft-ServerManagementExperience -After $CheckPoint | Select-Object TimeGenerated, EntryType, Message
#        $CheckPoint = Get-Date
#        Start-Sleep -Seconds 2
#    }
#}

.\users -username $wac_user -password $wac_password -Verbose
$CheckInstall = Get-ChildItem C:\WaC
if ($CheckInstall.Count -eq "0")
{
    Invoke-WebRequest -Uri 'https://go.microsoft.com/fwlink/p/?linkid=2194936' -OutFile 'c:\wac.msi'
    Start-Process c:\wac.msi -ArgumentList '/qn /L*v c:\log.txt SME_PORT=443 SSL_CERTIFICATE_OPTION=generate TRANSFORMS=wac-install.mst INSTALLFOLDER=C:\WaC' -Wait
    Remove-Item -Force 'c:\wac.msi'
    Remove-Item -Force 'c:\wac-install.mst'
    $ListCrt = Get-ChildItem 'Cert:\LocalMachine\My\'
    $Thumb = $ListCrt.Thumbprint
    Get-childItem -Path cert:\localMachine\my\$Thumb | Export-PfxCertificate -FilePath C:\WaC\wac.pfx -Password $certpass
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
    elseif ($ServiceState -eq "Stopeed") {
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
        Reg import c:\wac\software.reg
        Reg import c:\wac\log.reg
        Import-PfxCertificate -FilePath C:\WaC\wac.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $certpass -Exportable
        $ListCrt = Get-ChildItem 'Cert:\LocalMachine\My\'
        $Thumb = $ListCrt.Thumbprint
        netsh http add sslcert ipport=0.0.0.0:443 certhash=$Thumb appid="{98a42deb-1a89-4759-ab35-190796e9985a}"
        Restart-Service -Name ServerManagementGateway
        $CheckPoint = (Get-Date).AddSeconds(-2)
        #Check up continue des évenements de Windows Admin Center
        Checkup

    }

}
