Deface::Override.new(
  virtual_path:  'hosts/show',
  name:          'add_maskind_tab',
  insert_bottom: 'ul.nav-tabs',
  partial:       'maskindb/host_tab'
)

Deface::Override.new(
  virtual_path:  'hosts/show',
  name:          'add_maskindb_tab_pane',
  insert_bottom: 'div.tab-content',
  partial:       'maskindb/host_tab_pane'
)
