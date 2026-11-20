# Infrastructure (Bicep)

Infrastructure-as-code for the TaxiCab Streaming project, targeting Azure subscription resources.

Databricks **jobs and notebooks** are not deployed from this folder; see [app/streaming/README.md](../app/streaming/README.md).

## Layout

```
infra/
  bicep/
    main.bicep           # Subscription-scoped root (creates RG + modules)
    modules/
      monitoring.bicep   # Log Analytics workspace
      network.bicep      # VNet, subnets, NSGs
      security.bicep     # Key Vault (RBAC)
      storage.bicep      # ADLS Gen2 storage account
      messaging.bicep    # Service Bus Premium namespace + topic + subscriptions
    parameters/
      dev.bicepparam     # Dev environment parameters
```

## Phase 1 scope

This phase provisions the foundation only. Public network access is intentionally
left enabled for bootstrap and is locked down in Phase 3 (Private Endpoints).
IoT Hub and the simulator deployment arrive in later phases.

## Prerequisites

- Azure CLI, logged in: `az login`
- Bicep CLI (included with Azure CLI 2.59+): `az bicep version`
- Default subscription set: `az account show`

## Usage

```bash
cd infra/bicep

az bicep build --file main.bicep

# Preview changes
az deployment sub what-if \
  --location westeurope \
  --template-file main.bicep \
  --parameters parameters/dev.bicepparam

# Deploy
az deployment sub create \
  --name taxicab-dev \
  --location westeurope \
  --template-file main.bicep \
  --parameters parameters/dev.bicepparam
```

IaC state is ARM itself—subscription [deployment history](https://learn.microsoft.com/azure/azure-resource-manager/templates/deployment-history) records each deploy. Phase 5 CI may add an optional storage account for build artifacts only (not a Terraform-style state backend).

## Tear down

```bash
az group delete --name rg-taxicab-dev --yes --no-wait
```

Premium Service Bus and Log Analytics incur ongoing cost; delete the resource group when idle.