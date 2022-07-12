#Ajout d'arguments au script pour transporter les variables du dockerfile
param(

    [Parameter(Mandatory = $true)]
    [string]$username,

    [Parameter(Mandatory = $true)]
    [string]$password

)
#Déclaration de variable pour stocker le mot de passe chiffré
$secpass = ConvertTo-SecureString -AsPlainText $password -Force
#Création de l'utilisateur
New-LocalUser "$username" -Password $secpass -FullName "$username" -Description "Local admin $username"
#Ajout au groupe Administrateurs
Add-LocalGroupMember -Group "Administrators" -Member "$username"
#Affiche les membres du groupe administrateurs
Get-LocalGroupMember -Group "Administrators"