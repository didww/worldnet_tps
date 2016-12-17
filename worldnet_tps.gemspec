# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'worldnet_tps/version'

Gem::Specification.new do |spec|
  spec.name          = 'worldnet_tps'
  spec.version       = WorldnetTps::VERSION
  spec.authors       = ['Igor Fedoronchuk']
  spec.email         = ['fedoronchuk@gmail.com']
  spec.description   = %q{Ruby library for integrating with the Worldnet TPS gateway}
  spec.summary       = %q{Worldnet TPS Gateway Ruby Client Library}
  spec.homepage      = 'https://github.com/Fivell/worldnet_tps'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 4.1'
  spec.add_dependency 'builder', '~> 3.2'
  spec.add_dependency 'nokogiri', '~> 1.3'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'

end
