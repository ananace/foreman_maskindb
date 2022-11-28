# frozen_string_literal: true

module ForemanMaskindb
  module HostExtensions
    extend ActiveSupport::Concern

    def maskindb_entry
      hardware = mdb_query "#{SETTINGS[:maskindb_url]}/api/hardware/#{name}/"
      %i[datacenter rack model].each do |key|
        next unless hardware[key]

        data = mdb_query hardware[key]
        hardware[key] = data.reject { |k, _v| k == :url }.deep_symbolize_keys
      end

      server = mdb_query hardware[:server]
      %i[status admin backupadmin group].each do |key|
        next unless server[key]

        data = mdb_query server[key]
        server[key] = data.reject { |k, _v| k == :url }.deep_symbolize_keys
      end

      hardware.delete :server
      hardware.delete :url
      hardware.merge server
    rescue RestClient::Exceptions::EXCEPTIONS_MAP[404]
      # Ignore missing hosts
      nil
    end

    private

    def mdb_query(url)
      logger.debug "Rest call to #{url}..."
      data = JSON.parse(
        RestClient::Request.execute(
          method: :get,
          url: url,
          user: SETTINGS[:maskindb_user],
          password: SETTINGS[:maskindb_password],
          headers: {
            accept: 'application/json',
            accept_charset: 'utf-8'
          }
        ).body, symbolize_names: true
      )
      logger.debug "  #{url} => #{data}"
      data
    end
  end
end
