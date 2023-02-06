@description('Synapse Analytics name.')
param workspaceName string

param currentUTC string =utcNow()

@description('Key/Value pair of tags.')
param tags object = {}

@description('Location for the deployment.')
param location string = resourceGroup().location

@description('Azure AD principal name, in the format of firstname last name')
param aadLoginName string =''

@description('AAD account object id')
param aadLoginObjectID string=''

@description('AAD account type with options User, Group, Application. Default: Group')
@allowed([
  'User'
  'Group'
  'Application'
])
param aadLoginType string = 'Group'

resource storage 'Microsoft.Storage/storageAccounts@2020-08-01-preview'={
  name:'${toLower(workspaceName)}strg${toLower(substring(uniqueString(resourceGroup().name),0,3))}'
  tags: tags
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

resource synapseWorkspace 'Microsoft.Synapse/workspaces@2021-06-01'={
name: toLower(workspaceName)
tags: tags
dependsOn: [
  storage
]
location: location
identity : {
  type: 'SystemAssigned'
}
properties:{
  azureADOnlyAuthentication: true
  defaultDataLakeStorage:{
    accountUrl: storage.properties.primaryEndpoints.dfs
    filesystem:'synapse-fs'
  }
  managedResourceGroupName: '${workspaceName}_managed'
}
resource aadAuth 'administrators@2021-06-01'={
  name: 'activeDirectory'
  properties:{
    administratorType: aadLoginType
    login: aadLoginName
    sid: aadLoginObjectID
    tenantId: subscription().tenantId
  }
}
resource dedicatedSqlPool 'sqlPools@2021-06-01'={
  name: 'dedicatedSqlPool'
  location: location
  properties:{
    createMode: 'Default'
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    sku:{
      name: 'DW100c'
      tier: 'DataWarehouse'
    }
  }
}
}
