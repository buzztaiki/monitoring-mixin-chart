local utils = import './lib/utils.libsonnet';
local node = import 'github.com/prometheus/node_exporter/docs/node-mixin/mixin.libsonnet';

node {
  _config+:: {
    nodeExporterSelector: 'job="node-exporter"',
    showMultiCluster: true,
  },

  local dashboards = super.grafanaDashboards,
  grafanaDashboards:
    {
      [name]: dashboards[name]
      for name in std.objectFields(dashboards)
      if !(std.startsWith(name, 'nodes-aix') || std.startsWith(name, 'nodes-darwin'))
    }
    + utils.withBrowserTimezone(self),
}
