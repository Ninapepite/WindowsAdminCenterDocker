param(

    [Parameter(Mandatory = $true)]
    [string]$wac_user,

    [Parameter(Mandatory = $true)]
    [string]$wac_password
)
$log_install = get-content "c:\log.txt"
Write-Verbose "$log_install"
.\users -username $wac_user -password $wac_password -Verbose
$lastCheck = (Get-Date).AddSeconds(-2)
while ($true) {
    Get-EventLog -LogName Microsoft-ServerManagementExperience -After $lastCheck | Select-Object TimeGenerated, EntryType, Message
    $lastCheck = Get-Date
    Start-Sleep -Seconds 2
}
