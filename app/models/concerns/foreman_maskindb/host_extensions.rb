module ForemanMaskindb
  module HostExtensions
    extend ActiveSupport::Concern

    def maskindb_entry
      mdb_query = proc do |url|
        logger.debug "Rest call to #{url}..."
        data = JSON.parse(
          RestClient::Request.execute(
            method: :get,
            url: url,
            user: SETTINGS[:maskindb_user],
            password: SETTINGS[:maskindb_password],
            headers: {
              content_type: 'application/json',
              accept: 'application/json',
              accept_charset: 'utf-8'
            }
          ).body, symbolize_names: true
        )
        logger.debug "  #{url} => #{data}"
        data
      end.freeze

      begin
        hrd = mdb_query.call "#{SETTINGS[:maskindb_url]}/api/hardware/#{name}/"
        %i(datacenter rack model).each do |key|
          next unless hrd[key]

          data = mdb_query.call hrd[key]
          hrd[key] = data.reject { |k, _v| k == :url }.deep_symbolize_keys
        end

        srv = mdb_query.call hrd[:server]
        %i(status admin backupadmin group).each do |key|
          next unless srv[key]

          data = mdb_query.call srv[key]
          srv[key] = data.reject { |k, _v| k == :url }.deep_symbolize_keys
        end

        hrd.delete :server
        hrd.delete :url
        hrd.merge srv
      rescue RestClient::Exceptions::EXCEPTIONS_MAP[404]
        # Ignore missing hosts
        nil
      end
    end
  end
end
