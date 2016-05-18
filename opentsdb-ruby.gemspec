# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'cloudinsight/opentsdb/version'

Gem::Specification.new do |spec|
  spec.name          = 'opentsdb-ruby'
  spec.version       = CloudInsight::Opentsdb::VERSION
  spec.authors       = %w(lizhe luyingrui)
  spec.email         = ['lnz013@qq.com', 'luyingrui@oneapm.com']

  spec.summary       = 'Ruby client for OpenTSDB HTTP Query API.'
  spec.description   = 'A ruby client library for querying data by OpenTSDB HTTP API.'
  spec.homepage      = 'https://github.com/cloudinsight/opentsdb-ruby'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = Dir['lib/**/*.rb', 'examples/**/*.rb', 'README.md']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.licenses      = 'MIT'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'rubocop', '~> 0.40'
  spec.add_development_dependency 'guard', '~> 2.13'
  spec.add_development_dependency 'listen', '~> 3.0', '>= 3.0.8'
  spec.add_development_dependency 'guard-minitest', '~> 2.4'
  spec.add_development_dependency 'mocha', '~> 1.1'
  spec.add_development_dependency 'pry', '~> 0.10'
  spec.required_ruby_version = '>= 2.0.0'
end
