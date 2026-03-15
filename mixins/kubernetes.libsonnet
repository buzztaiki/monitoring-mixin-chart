local utils = import './lib/utils.libsonnet';
local kubernetes = import 'github.com/kubernetes-monitoring/kubernetes-mixin/mixin.libsonnet';

kubernetes {
  _config+:: {
    showMultiCluster: true,
  },

  local dashboards = super.grafanaDashboards,
  grafanaDashboards:
    {
      [name]: dashboards[name]
      for name in std.objectFields(dashboards)
      if !(std.startsWith(name, 'k8s-resources-windows') || std.startsWith(name, 'k8s-windows'))
    }
    + utils.withBrowserTimezone(self),
}
