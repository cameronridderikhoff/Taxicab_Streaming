@description('Resource name prefix (project-environment).')
param namePrefix string

@description('Azure region.')
param location string

@description('VNet CIDR.')
param addressSpace string

@description('Common tags.')
param tags object

resource vnet 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-${namePrefix}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
  }
}

resource nsgSimulator 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-simulator-${namePrefix}'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'DenyInternetInbound'
        properties: {
          priority: 4000
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nsgManagement 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-management-${namePrefix}'
  location: location
  tags: tags
  properties: {
    securityRules: [
      {
        name: 'DenyInternetInbound'
        properties: {
          priority: 4000
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: 'Internet'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource simulatorSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-simulator'
  properties: {
    addressPrefix: cidrSubnet(addressSpace, 8, 1)
    networkSecurityGroup: {
      id: nsgSimulator.id
    }
  }
}

resource privateEndpointsSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-private-endpoints'
  properties: {
    addressPrefix: cidrSubnet(addressSpace, 8, 2)
    privateEndpointNetworkPolicies: 'Enabled'
  }
}

resource managementSubnet 'Microsoft.Network/virtualNetworks/subnets@2024-05-01' = {
  parent: vnet
  name: 'snet-management'
  properties: {
    addressPrefix: cidrSubnet(addressSpace, 8, 3)
    networkSecurityGroup: {
      id: nsgManagement.id
    }
  }
}

output vnetId string = vnet.id
output vnetName string = vnet.name
output subnetIds object = {
  simulator: simulatorSubnet.id
  private_endpoints: privateEndpointsSubnet.id
  management: managementSubnet.id
}