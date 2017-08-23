module ForemanMaskindb
  module HostExtensions
    extend ActiveSupport::Concern

    def maskindb_entry
      Rails.cache.fetch("#{cache_key}/maskindb_entry", expires_in: 15.minutes) do
        begin
          srv = JSON.parse(
            RestClient::Request.execute(
              method: :get,
              url: "#{SETTINGS[:maskindb_url]}/api/servers/#{name}/",
              user: SETTINGS[:maskindb_user],
              password: SETTINGS[:maskindb_password],
              headers: {
                content_type: 'application/json',
                accept: 'application/json',
                accept_charset: 'utf-8'
              }
            ).body, symbolize_names: true
          )

          %i(status admin backupadmin group).each do |key|
            next unless srv[key]

            data = JSON.parse(
              RestClient::Request.execute(
                method: :get,
                url: srv[key],
                user: SETTINGS[:maskindb_user],
                password: SETTINGS[:maskindb_password],
                headers: {
                  content_type: 'application/json',
                  accept: 'application/json',
                  accept_charset: 'utf-8'
                }
              ).body, symbolize_names: true
            )

            srv[key] = data.reject { |k, _v| k == :url }.deep_symbolize_keys
          end

          srv
        rescue RestClient::NotFound
          nil
        end
      end
    end
  end
end
