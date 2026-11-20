targetScope = 'subscription'

@description('Short project name used as a prefix for resource names.')
param project string = 'taxicab'

@description('Deployment environment (e.g. dev, staging).')
param environment string = 'dev'

@description('Azure region for all resources.')
param location string = 'westeurope'

@description('Service Bus Premium messaging units (1, 2, 4, 8, 16).')
@allowed([
  1
  2
  4
  8
  16
])
param servicebusCapacity int = 1

@description('VNet CIDR. Subnets are carved out with /24 prefixes.')
param addressSpace string = '10.20.0.0/16'

@description('Common tags applied to all resources.')
param tags object = {
  project: 'taxicab-streaming'
  managed_by: 'bicep'
  purpose: 'peex-pet-project'
}

var namePrefix = '${project}-${environment}'
// Globally-unique resources (storage, key vault, service bus) get a short suffix.
var suffix = take(uniqueString(subscription().id, project, environment, location), 5)
var mergedTags = union(tags, {
  environment: environment
})

resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: 'rg-${namePrefix}'
  location: location
  tags: mergedTags
}

module monitoring 'modules/monitoring.bicep' = {
  scope: rg
  name: 'monitoring-deployment'
  params: {
    namePrefix: namePrefix
    location: location
    tags: mergedTags
  }
}

module network 'modules/network.bicep' = {
  scope: rg
  name: 'network-deployment'
  params: {
    namePrefix: namePrefix
    location: location
    addressSpace: addressSpace
    tags: mergedTags
  }
}

module security 'modules/security.bicep' = {
  scope: rg
  name: 'security-deployment'
  params: {
    namePrefix: namePrefix
    suffix: suffix
    location: location
    tenantId: deployer().tenantId
    adminObjectId: deployer().objectId
    logAnalyticsId: monitoring.outputs.workspaceId
    tags: mergedTags
  }
}

module storage 'modules/storage.bicep' = {
  scope: rg
  name: 'storage-deployment'
  params: {
    namePrefix: namePrefix
    suffix: suffix
    location: location
    tags: mergedTags
  }
}

module messaging 'modules/messaging.bicep' = {
  scope: rg
  name: 'messaging-deployment'
  params: {
    namePrefix: namePrefix
    suffix: suffix
    location: location
    capacity: servicebusCapacity
    logAnalyticsId: monitoring.outputs.workspaceId
    tags: mergedTags
  }
}

output resourceGroupName string = rg.name
output location string = rg.location
output vnetId string = network.outputs.vnetId
output subnetIds object = network.outputs.subnetIds
output logAnalyticsWorkspaceId string = monitoring.outputs.workspaceId
output keyVaultUri string = security.outputs.keyVaultUri
output storageAccountName string = storage.outputs.storageAccountName
output servicebusNamespaceName string = messaging.outputs.namespaceName
output servicebusTopicName string = messaging.outputs.topicName