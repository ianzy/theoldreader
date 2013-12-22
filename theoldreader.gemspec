# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'theoldreader/version'

Gem::Specification.new do |gem|
  gem.name          = "theoldreader"
  gem.version       = Theoldreader::VERSION
  gem.authors       = ["Ian Zhang"]
  gem.email         = ["ian7zy@gmail.com"]
  gem.description   = %q{Ruby integrations for theoldreader API}
  gem.summary       = %q{Ruby integrations for theoldreader API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency("multi_json")
  gem.add_runtime_dependency("faraday")
  gem.add_runtime_dependency("addressable")
  gem.add_development_dependency("rspec")
  gem.add_development_dependency("rake")
end
