@description('The name of the Azure Databricks workspace to create.')
param workspaceName string

@allowed([
  'trial'
  'standard'
  'premium'
])
@description('The pricing tier of workspace.')
param pricingTier string = 'premium'

@description('The complete ARM resource Id of the custom virtual network.')
param customVirtualNetworkId string

@description('The name of the public subnet in the custom VNet.')
param customSubnetAName string = 'subnet-A'

@description('The name of the private subnet in the custom VNet.')
param customSubnetBName string = 'subnet-B'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the managed Resource Group controlled by the workspace')
param managedResourceGroup string = '${workspaceName}_managed'



var managedResourceGroupId = '${subscription().id}/resourceGroups/${managedResourceGroup}'

resource workspaceName_resource 'Microsoft.Databricks/workspaces@2018-04-01' = {
  location: location
  name: workspaceName
  sku: {
    name: pricingTier
  }
  properties: {
    managedResourceGroupId: managedResourceGroupId
    parameters: {
      customVirtualNetworkId: {
        value: customVirtualNetworkId
      }
      customPublicSubnetName: {
        value: customSubnetAName
      }
      customPrivateSubnetName: {
        value: customSubnetBName
      }
      enableNoPublicIp:{
        value:true
      }
     

    }
  }
}
