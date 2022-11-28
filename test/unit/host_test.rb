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
      host.expects(:mdb_query).with('http://example.com/api/hardware/example').once.returns '{"rack":"http://example.com/api/rack/example"}'
      host.expects(:mdb_query).with('http://example.com/api/rack/example').once.returns '{"name":"Example"}'

      assert_equal({ rack: { name: 'Example' } }, host.maskindb_entry)
    end
  end

  context 'Without MaskinDB entry' do
    test 'it should handle failing to retrieve the MaskinDB data' do
      host
        .expects(:mdb_query)
        .with('http://example.com/api/hardware/example')
        .once
        .raises RestClient::Exceptions::EXCEPTIONS_MAP[404]

      assert_nil host.maskindb_entry
    end
  end
end
