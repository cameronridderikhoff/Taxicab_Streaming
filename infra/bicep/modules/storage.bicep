@description('Resource name prefix (project-environment).')
param namePrefix string

@description('Short suffix for global uniqueness.')
param suffix string

@description('Azure region.')
param location string

@description('Common tags.')
param tags object

// Storage account names: lowercase alphanumeric, 3-24 chars, globally unique.
var storageAccountName = take('st${replace(namePrefix, '-', '')}${suffix}', 24)

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    isHnsEnabled: true
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    publicNetworkAccess: 'Enabled'
  }
}

resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccount
  name: 'default'
}

// ADLS Gen2 filesystem (HNS-enabled container).
resource processedFilesystem 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: blobService
  name: 'processed'
  properties: {
    publicAccess: 'None'
  }
}

output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
output processedFilesystemName string = processedFilesystem.name