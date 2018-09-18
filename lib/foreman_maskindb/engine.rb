require 'deface'

module ForemanMaskindb
  class Engine < ::Rails::Engine
    engine_name 'foreman_maskindb'

    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    initializer 'foreman_hyperv.register_plugin', before: :finisher_hook do
      Foreman::Plugin.register :foreman_maskindb do
        requires_foreman '>= 1.14'

        Foreman::AccessControl.permission(:view_hosts).actions.concat [
          'hosts/maskindb'
        ]
      end
    end

    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanMaskindb::HostExtensions)
        HostsController.send(:include, ForemanMaskindb::HostsControllerExtensions)
      rescue => e
        puts "ForemanMaskindb: skipping engine hook (#{e})"
      end
    end
  end
end
