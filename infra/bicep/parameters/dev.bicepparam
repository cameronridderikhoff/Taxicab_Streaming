using '../main.bicep'

param project = 'taxicab'
param environment = 'dev'
param location = 'westeurope'

// Service Bus Premium messaging units. Start at 1; bump to 2/4 during the
// PeEx Streaming 01 broker tuning exercise to observe throughput changes.
param servicebusCapacity = 1