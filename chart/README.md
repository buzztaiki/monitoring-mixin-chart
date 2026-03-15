# monitoring-mixin

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

A Helm chart for monitoring-mixins

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

