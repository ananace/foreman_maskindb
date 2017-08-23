module ForemanMaskindb
  module HostExtensions
    extend ActiveSupport::Concern

    def maskindb_entry
      Rails.cache.fetch("#{cache_key}/maskindb_entry", expires_in: 15.minutes) do
        begin
          hrd = JSON.parse(
            RestClient::Request.execute(
              method: :get,
              url: "#{SETTINGS[:maskindb_url]}/api/hardware/#{name}/",
              user: SETTINGS[:maskindb_user],
              password: SETTINGS[:maskindb_password],
              headers: {
                content_type: 'application/json',
                accept: 'application/json',
                accept_charset: 'utf-8'
              }
            ).body, symbolize_names: true
          )

          %i(datacenter rack model).each do |key|
            next unless hrd[key]

            data = JSON.parse(
              RestClient::Request.execute(
                method: :get,
                url: hrd[key],
                user: SETTINGS[:maskindb_user],
                password: SETTINGS[:maskindb_password],
                headers: {
                  content_type: 'application/json',
                  accept: 'application/json',
                  accept_charset: 'utf-8'
                }
              ).body, symbolize_names: true
            )

            hrd[key] = data.reject { |k, _v| k == :url }.deep_symbolize_keys
          end

          srv = JSON.parse(
            RestClient::Request.execute(
              method: :get,
              url: hrd[:server],
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

          hrd.delete :server
          hrd.delete :url
          hrd.merge srv
        rescue RestClient::NotFound
          nil
        end
      end
    end
  end
end
