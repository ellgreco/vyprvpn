
#Install-Module -Name VPNCredentialsHelper

if (Get-Module -ListAvailable -Name VPNCredentialsHelper) {
    Write-Host "Module exists"
} 
else {
    Write-Host "VPNCredentialsHelper Module does not exist" -ForegroundColor Red
    write-host "Install-Module -Name VPNCredentialsHelper" -ForegroundColor Red
    
}

#Credentials
$username = "username"
$password = "password"


#servers
$servers = Import-Csv -Delimiter "," -Path .\servers.csv

$servers | ForEach-Object {

    #vpn name
    $vName = ("VYPR-" + $_.city).ToLower()

    #Specifying configuration
    $vpnArguments = @{
        Name = $vName
        TunnelType =  "ikeV2"
        ServerAddress = $_.Hostname
        EncryptionLevel = "Maximum" 
        RememberCredential = $true 
        SplitTunneling = $false 
        AuthenticationMethod = "Eap" 
        Force = $true 
        AllUserConnection = $false
      }

    
    #Creating the vpn connection
    Add-VpnConnection @vpnArguments

    #Saving the vpn connections password 
    Set-VpnConnectionUsernamePassword -connectionname $vName -username $username -password $password -domain '' 

}
