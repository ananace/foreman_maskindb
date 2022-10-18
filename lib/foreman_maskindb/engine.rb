# frozen_string_literal: true

require 'deface'

module ForemanMaskindb
  class Engine < ::Rails::Engine
    engine_name 'foreman_maskindb'

    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    initializer 'foreman_hyperv.register_plugin', before: :finisher_hook do
      Foreman::Plugin.register :foreman_maskindb do
        requires_foreman '>= 1.14'

        Foreman::AccessControl.permission(:view_hosts).actions << 'hosts/maskindb'
      end
    end

    config.to_prepare do
      Host::Managed.prepend ForemanMaskindb::HostExtensions
      HostsController.prepend ForemanMaskindb::HostsControllerExtensions
    rescue StandardError => e
      puts "ForemanMaskindb: skipping engine hook (#{e})"
    end
  end
end
