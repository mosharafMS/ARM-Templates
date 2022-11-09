param workspaceName string
param sqlAdminLogin string
@secure()
param sqlAdminPass string 
param currentUTC string =utcNow()
param location string = resourceGroup().location

resource storage 'Microsoft.Storage/storageAccounts@2020-08-01-preview'={
  name:'${toLower(workspaceName)}strg${toLower(substring(uniqueString(currentUTC),0,3))}'
  location: location
  kind:'StorageV2'
  sku:{
    name:'Standard_LRS'
  }
  properties:{
    accessTier:'Hot'
    supportsHttpsTrafficOnly:true
    isHnsEnabled:true
  }
}

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2020-12-01'={
name: toLower(workspaceName)
location: resourceGroup().location
identity : {
  type: 'SystemAssigned'
}
properties:{
  defaultDataLakeStorage:{
    accountUrl: storage.properties.primaryEndpoints.dfs
    filesystem:'synapse-fs'
  }
  sqlAdministratorLogin:sqlAdminLogin
  sqlAdministratorLoginPassword : sqlAdminPass
  managedResourceGroupName: '${workspaceName}_managed'
}
}

