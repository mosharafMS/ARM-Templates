// ----------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
//
// THIS CODE AND INFORMATION ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND, 
// EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND/OR FITNESS FOR A PARTICULAR PURPOSE.
// ----------------------------------------------------------------------------------

@description('SQL Database Logical Server Name.')
param sqlServerName string

@description('Key/Value pair of tags.')
param tags object = {}

// Networking
@description('Private Endpoint Subnet Resource Id.')
param privateEndpointSubnetId string

@description('Private DNS Zone Resource Id.')
param privateZoneId string

// Credentials
@description('SQL Database Username.')
@secure()
param sqldbUsername string

@description('SQL Database Password.')
@secure()
param sqldbPassword string

resource sqlserver 'Microsoft.Sql/servers@2019-06-01-preview' = {
  tags: tags
  location: resourceGroup().location
  name: sqlServerName
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: sqldbUsername
    administratorLoginPassword: sqldbPassword
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Disabled'
  }
}


resource sqlserver_pe 'Microsoft.Network/privateEndpoints@2020-06-01' = {
  location: resourceGroup().location
  name: '${sqlserver.name}-endpoint'
  properties: {
    subnet: {
      id: privateEndpointSubnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${sqlserver.name}-endpoint'
        properties: {
          privateLinkServiceId: sqlserver.id
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }

  resource sqlserver_pe_dns_reg 'privateDnsZoneGroups@2020-06-01' = {
    name: 'default'
    properties: {
      privateDnsZoneConfigs: [
        {
          name: 'privatelink_database_windows_net'
          properties: {
            privateDnsZoneId: privateZoneId
          }
        }
      ]
    }
  }
}

// Outputs
output sqlDbFqdn string = sqlserver.properties.fullyQualifiedDomainName
