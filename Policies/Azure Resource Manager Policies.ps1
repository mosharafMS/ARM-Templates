<#Paramaters

#>
$subscriptionName = "Visual Studio Ultimate with MSDN"

$PolicyFileName="ARM Policies-Restrict Services.json"



Login-AzureRMAccount -ErrorAction Stop


Select-AzureRmSubscription -SubscriptionName $subscriptionName
$subscriptionID = (Get-AzureRmSubscription -SubscriptionName $subscriptionName).SubscriptionId

#hacking the resource providers & types
<#
$selectedProvider=Get-AzureRmResourceProvider -ListAvailable | Out-GridView -PassThru
$selectedProvider
$selectedType=(Get-AzureRmResourceProvider -ProviderNamespace $selectedProvider.ProviderNamespace).ResourceTypes | Out-GridView -PassThru
$selectedType
#>

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$policy=New-AzureRmPolicyDefinition -Name "whitelist" -Description "whitelisting specific services using types.The list includes Virtual machines,ExpressRoute,VPN gateways,Storage,virtual networks,Backup, Site recovery, DevTest labs, Key vault, Azure App Services,SQL Database" -Policy "$scriptDir\$PolicyFileName"

New-AzureRmPolicyAssignment -Name "whitelistAssignment" -Scope /subscriptions/$subscriptionID -PolicyDefinition $policy



#remove
# Remove-AzureRmPolicyAssignment -Name "whitelistAssignment" -Scope /subscriptions/$subscriptionID
