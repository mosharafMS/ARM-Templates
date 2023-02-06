param VNetName string = 'mainVnet'
param VnetLocation string = 'CanadaCentral'
param subnets_web_name string = 'web'
param subnets_MiddleWare_name string = 'MiddleWare'
param subnets_Restricted_name string = 'Restricted'

resource VNetName_resource 'Microsoft.Network/virtualNetworks@2017-06-01' = {
  name: VNetName
  location: VnetLocation
  scale: null
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.100.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnets_web_name
        properties: {
          addressPrefix: '10.100.1.0/24'
        }
      }
      {
        name: subnets_MiddleWare_name
        properties: {
          addressPrefix: '10.100.2.0/24'
        }
      }
      {
        name: subnets_Restricted_name
        properties: {
          addressPrefix: '10.100.3.0/24'
        }
      }
    ]
    virtualNetworkPeerings: []
  }
  dependsOn: []
}

resource VNetName_subnets_web_name 'Microsoft.Network/virtualNetworks/subnets@2017-06-01' = {
  parent: VNetName_resource
  name: '${subnets_web_name}'
  scale: null
  properties: {
    addressPrefix: '10.100.1.0/24'
  }
}

resource VNetName_subnets_MiddleWare_name 'Microsoft.Network/virtualNetworks/subnets@2017-06-01' = {
  parent: VNetName_resource
  name: '${subnets_MiddleWare_name}'
  scale: null
  properties: {
    addressPrefix: '10.100.2.0/24'
  }
}

resource VNetName_subnets_Restricted_name 'Microsoft.Network/virtualNetworks/subnets@2017-06-01' = {
  parent: VNetName_resource
  name: '${subnets_Restricted_name}'
  scale: null
  properties: {
    addressPrefix: '10.100.3.0/24'
  }
}

output vnetID string = ''
output subwebID string = ''
output submiddleID string = ''
output subrestrictedID string = ''
