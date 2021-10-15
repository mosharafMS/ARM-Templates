
param(
    [string]
    $subscriptionId,
   
    [Parameter(Mandatory=$True)]
    [string]
    $location,
   
    [string]
    $templateFilePath = "template.json",
   
    [string]
    $parametersFilePath = "parameters.json"
   )

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

#check if already logged in
$context=Get-AzContext

If($null-eq $context )
{
    # sign in
    Write-Host "Logging in...";
    Login-AzAccount;
}else{
    Write-Host "Already logged in"
}

# select subscription
if($subscriptionId -ne $null)
{
    Write-Host "Selecting subscription '$subscriptionId'";
    Select-AzSubscription -SubscriptionID $subscriptionId;
}

$deploymentName= "Deployment-$(New-Guid)" 

New-AzSubscriptionDeployment -Name $deploymentName -Location $location `
-TemplateFile $templateFilePath -TemplateParameterFile $parametersFilePath `
