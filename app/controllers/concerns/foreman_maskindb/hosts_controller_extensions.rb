module ForemanMaskindb
  module HostsControllerExtensions
    extend ActiveSupport::Concern

    def maskindb
      # Can't add a before_action for `find_resource` without overriding code actions
      find_resource
      @maskindb_entry = @host.maskindb_entry
      render partial: 'maskindb/information'
    rescue ActionView::Template::Error => exception
      process_ajax_error exception, 'fetch maskindb information'
    end

    private

    def action_permission
      case params[:action]
      when 'maskindb'
        :view_hosts
      else
        super
      end
    end
  end
end
