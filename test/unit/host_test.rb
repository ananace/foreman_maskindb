# frozen_string_literal: true

require 'test_plugin_helper'

class HostTest < ActiveSupport::TestCase
  setup do
    User.current = FactoryBot.build(:user, :admin)
    SETTINGS[:maskindb_url] = 'http://example.com'
  end

  let(:host) { FactoryBot.create :host, :managed }

  context 'With MaskinDB entry' do
    test 'it should retrieve the MaskinDB data' do
      hardware_data = {
        rack: "#{SETTINGS[:maskindb_url]}/api/rack/example/",
        model: "#{SETTINGS[:maskindb_url]}/api/model/example/",
        server: "#{SETTINGS[:maskindb_url]}/api/servers/#{host.name}/"
      }
      rack_data = {
        name: 'Example'
      }
      model_data = {
        name: 'Example'
      }
      server_data = {
        name: 'Example',
        status: "#{SETTINGS[:maskindb_url]}/api/status/example/"
      }
      status_data = {
        name: 'Active'
      }

      expected_data = {
        rack: rack_data,
        model: model_data,
      }.merge(server_data).merge(status: status_data)

      host.expects(:mdb_query).with("http://example.com/api/hardware/#{host.name}/").once.returns hardware_data
      host.expects(:mdb_query).with('http://example.com/api/rack/example/').once.returns rack_data
      host.expects(:mdb_query).with('http://example.com/api/model/example/').once.returns model_data
      host.expects(:mdb_query).with("http://example.com/api/servers/#{host.name}/").once.returns server_data
      host.expects(:mdb_query).with('http://example.com/api/status/example/').once.returns status_data

      assert_equal expected_data, host.maskindb_entry
    end
  end

  context 'Without MaskinDB entry' do
    test 'it should handle failing to retrieve the MaskinDB data' do
      host
        .expects(:mdb_query)
        .with("http://example.com/api/hardware/#{host.name}/")
        .once
        .raises RestClient::Exceptions::EXCEPTIONS_MAP[404]

      assert_nil host.maskindb_entry
    end
  end
end
