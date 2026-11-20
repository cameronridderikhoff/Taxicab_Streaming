# Databricks streaming workload

Azure **subscription resources** (IoT Hub, Databricks workspace, ADLS, Service Bus, networking) live under `infra/bicep/`.

**Workspace configuration**—jobs, clusters, notebooks, secret scopes, and the Structured Streaming PySpark code—is deployed from this folder with [Databricks Asset Bundles](https://docs.databricks.com/en/dev-tools/bundles/index.html), not Bicep. ARM/Bicep only creates the `Microsoft.Databricks/workspaces` resource; jobs and notebooks are workspace APIs.

## Layout (Phase 2+)

```
app/streaming/
  databricks.yml          # Bundle definition (jobs, cluster policies, variables)
  src/                    # PySpark streaming job (bronze → silver → gold)
  README.md
```

## Deploy (after workspace exists)

```bash
cd app/streaming
databricks bundle validate
databricks bundle deploy -t dev
```

CI/CD runs `databricks bundle deploy` in the Azure DevOps pipeline after the Bicep deployment stage (see roadmap Phase 5).

## Tuning knobs (Streaming 02)

Job parameters in `databricks.yml` / the PySpark entrypoint expose trigger interval, `maxEventsPerTrigger`, watermark, shuffle partitions, and cluster autoscaling bounds for the PeEx tuning exercises.