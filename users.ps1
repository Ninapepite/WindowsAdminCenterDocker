param(

    [Parameter(Mandatory = $true)]
    [string]$username,

    [Parameter(Mandatory = $true)]
    [string]$password

)
$secpass = ConvertTo-SecureString -AsPlainText $password -Force
New-LocalUser "$username" -Password $secpass -FullName "$username" -Description "Local admin $username"
Add-LocalGroupMember -Group "Administrators" -Member "$username"
Get-LocalGroupMember -Group "Administrators"