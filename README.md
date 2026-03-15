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

<!-- helm-docs:start -->
## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alert.annotations | object | `{}` | Extra annotations for the alerting rules PrometheusRule |
| alert.labels | object | `{}` | Extra labels for the alerting rules PrometheusRule |
| dashboard.annotations | object | `{}` | Extra annotations for dashboard ConfigMaps |
| dashboard.folderAnnotation | string | `"grafana_folder"` | Annotation key used to specify the Grafana folder |
| dashboard.folderName | string | `""` | Grafana folder name to store dashboards in (empty means General) |
| dashboard.labels | object | `{}` | Extra labels for dashboard ConfigMaps |
| dashboard.markerLabel | string | `"grafana_dashboard"` | Label key used by Grafana to discover dashboards |
| dashboard.markerLabelValue | string | `"1"` | Value for the markerLabel |
| fullnameOverride | string | `""` | Override the full resource name |
| mixinName | string | `""` | Name of the mixin placed under generated/. e.g. kubernetes, node-exporter |
| nameOverride | string | `""` | Override the resource name prefix |
| rule.annotations | object | `{}` | Extra annotations for the recording rules PrometheusRule |
| rule.labels | object | `{}` | Extra labels for the recording rules PrometheusRule |
| useReleaseNameAsFullName | bool | `true` | If true, use the release name as the full resource name, ignoring nameOverride/fullnameOverride |
<!-- helm-docs:end -->

## License

MIT
