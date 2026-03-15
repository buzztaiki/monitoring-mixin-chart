set quiet
jsonnet_vendor := "jsonnet_vendor"

# Install jsonnet dependencies
install *args:
    go tool jb install --jsonnetpkg-home {{jsonnet_vendor}} {{args}}

# Update jsonnet dependencies
update *args:
    go tool jb update --jsonnetpkg-home {{jsonnet_vendor}} {{args}}

# Generate alerts, rules, and dashboards for all mixins
generate: install
    #!/bin/bash -e
    for f in mixins/*.libsonnet; do
      mixin=$(basename $f .libsonnet)
      just generate_mixin $mixin
    done

# Generate alerts, rules, and dashboards for a specific mixin
generate_mixin mixin:
    #!/bin/bash -e
    generated=chart/generated/{{mixin}}
    rm -rf $generated && mkdir -p $generated/dashboards
    just render_alerts {{mixin}} | yq -P > $generated/alerts.yaml
    just render_rules {{mixin}} | yq -P > $generated/rules.yaml
    just render_dashboards {{mixin}} --multi $generated/dashboards >/dev/null

# Lint and format-check all jsonnet files
check:
    find mixins -name '*.jsonnet' -o -name '*.libsonnet' | xargs -n 1 go tool jsonnet-lint -J {{jsonnet_vendor}} --
    find mixins -name '*.jsonnet' -o -name '*.libsonnet' | xargs go tool jsonnetfmt --test --

# Format all jsonnet files in-place
fmt:
    find mixins -name '*.jsonnet' -o -name '*.libsonnet' | xargs go tool jsonnetfmt -i --

# Generate README.md values section from chart/values.yaml
docs:
    go tool helm-docs --chart-search-root=chart --output-file=../README.md

# Render PrometheusRule alerts JSON for a mixin
render_alerts mixin *args:
    go tool jsonnet -J {{jsonnet_vendor}} {{args}} -e '(import "./mixins/{{mixin}}.libsonnet").prometheusAlerts'
# Render PrometheusRule recording rules JSON for a mixin
render_rules mixin *args:
    go tool jsonnet -J {{jsonnet_vendor}} {{args}} -e '(import "./mixins/{{mixin}}.libsonnet").prometheusRules'
# Render Grafana dashboard JSON for a mixin
render_dashboards mixin *args:
    go tool jsonnet -J {{jsonnet_vendor}} {{args}} -e '(import "./mixins/{{mixin}}.libsonnet").grafanaDashboards'
