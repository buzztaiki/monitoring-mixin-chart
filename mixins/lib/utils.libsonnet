{
  // withBrowserTimezone sets timezone to 'browser' for all dashboards.
  withBrowserTimezone(dashboards): {
    [name]: { timezone: 'browser' }
    for name in std.objectFields(dashboards)
  },
}
