@description('Resource name prefix (project-environment).')
param namePrefix string

@description('Short suffix for global uniqueness.')
param suffix string

@description('Azure region.')
param location string

@description('Service Bus Premium messaging units.')
param capacity int

@description('Log Analytics workspace ID for diagnostics.')
param logAnalyticsId string

@description('Common tags.')
param tags object

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' = {
  name: 'sb-${namePrefix}-${suffix}'
  location: location
  tags: tags
  sku: {
    name: 'Premium'
    tier: 'Premium'
    capacity: capacity
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    minimumTlsVersion: '1.2'
  }
}

resource tripsTopic 'Microsoft.ServiceBus/namespaces/topics@2022-10-01-preview' = {
  parent: namespace
  name: 'taxi-trips'
  properties: {
    defaultMessageTimeToLive: 'PT1H'
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    requiresDuplicateDetection: true
  }
}

resource fabricStreamSub 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  parent: tripsTopic
  name: 'fabric-stream'
  properties: {
    maxDeliveryCount: 10
    lockDuration: 'PT30S'
  }
}

resource monitoringTapSub 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' = {
  parent: tripsTopic
  name: 'monitoring-tap'
  properties: {
    maxDeliveryCount: 10
    lockDuration: 'PT30S'
  }
}

resource sbDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: namespace
  name: 'diag-servicebus'
  properties: {
    workspaceId: logAnalyticsId
    logs: [
      {
        category: 'OperationalLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

output namespaceId string = namespace.id
output namespaceName string = namespace.name
output topicName string = tripsTopic.name
output fabricSubscriptionName string = fabricStreamSub.name