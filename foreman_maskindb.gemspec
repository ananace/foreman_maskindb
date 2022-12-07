# frozen_string_literal: true

require File.join File.expand_path('lib', __dir__), 'foreman_maskindb/version'

Gem::Specification.new do |spec|
  spec.name          = 'foreman_maskindb'
  spec.version       = ForemanMaskindb::VERSION
  spec.authors       = ['Alexander Olofsson']
  spec.email         = ['alexander.olofsson@liu.se']

  spec.summary       = 'Display MaskinDB entries for servers'
  spec.description   = 'Foreman plugin that links servers with the LiU-IT MaskinDB'
  spec.homepage      = 'https://github.com/ananace/foreman_maskindb'
  spec.license       = 'GPL-3.0'

  spec.files         = Dir['{app,config,db,lib}/**/*.*'] + %w[LICENSE.txt README.md]

  spec.add_dependency 'deface'

  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-performance'
  spec.add_development_dependency 'rubocop-rails'
end
