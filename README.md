# monitoring-mixin-chart

A template repository for packaging [monitoring mixins](https://monitoring.mixins.dev/) as a Helm chart.

The chart deploys the following resources from pre-generated mixin files:

- `PrometheusRule` for alerting rules
- `PrometheusRule` for recording rules
- `ConfigMap` per dashboard (for Grafana sidecar)

## Repository structure

```
chart/                   Helm chart
  generated/<mixin>/     Generated alerts, rules, and dashboards
mixins/                  Jsonnet mixin definitions
justfile                 Commands for generating and maintaining mixin files
example/                 Example helmfile setup
```

## Requirements

- [just](https://github.com/casey/just)
- Go (used to run `jb` and `jsonnet` via `go tool`)
- [yq](https://github.com/mikefarah/yq)

## Adding a mixin

1. Add the mixin as a dependency in `jsonnetfile.json`:

   ```sh
   just install <mixin-package>
   ```

2. Create `mixins/<mixin-name>.libsonnet` that imports and configures the mixin.

3. Generate the files:

   ```sh
   just generate
   ```

   This writes `alerts.yaml`, `rules.yaml`, and dashboard JSON files under `chart/generated/<mixin-name>/`.

## Deploying

Install the chart once per mixin, specifying `mixinName` to select which generated files to use.

```sh
helm install kubernetes-mixin ./chart \
  --namespace monitoring \
  --set mixinName=kubernetes \
  --set dashboard.folderName=Kubernetes
```

See `example/helmfile.yaml` for a helmfile-based example that installs both `kubernetes` and `node-exporter` mixins alongside `kube-prometheus-stack`.

## Values

| Key | Default | Description |
|-----|---------|-------------|
| `mixinName` | `""` | Name of the mixin under `chart/generated/`. Required, must not be empty. |
| `useReleaseNameAsFullName` | `true` | Use the Helm release name as the full resource name. |
| `nameOverride` | `""` | Override the resource name prefix. |
| `fullnameOverride` | `""` | Override the full resource name. |
| `rule.labels` | `{}` | Extra labels for the recording rules `PrometheusRule`. |
| `rule.annotations` | `{}` | Extra annotations for the recording rules `PrometheusRule`. |
| `alert.labels` | `{}` | Extra labels for the alerting rules `PrometheusRule`. |
| `alert.annotations` | `{}` | Extra annotations for the alerting rules `PrometheusRule`. |
| `dashboard.labels` | `{}` | Extra labels for dashboard `ConfigMap`s. |
| `dashboard.annotations` | `{}` | Extra annotations for dashboard `ConfigMap`s. |
| `dashboard.markerLabel` | `grafana_dashboard` | Label key used by Grafana to discover dashboards. |
| `dashboard.markerLabelValue` | `"1"` | Value for `markerLabel`. |
| `dashboard.folderAnnotation` | `grafana_folder` | Annotation key used to specify the Grafana folder. |
| `dashboard.folderName` | `""` | Grafana folder name (empty means General). |
