# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lbf/version'

Gem::Specification.new do |spec|
  spec.name          = "LBF"
  spec.version       = LBF::VERSION
  spec.authors       = ["Forrest Fleming"]
  spec.email         = ["ffleming@oversee.net"]
  spec.summary       = %q{Gem for making requests from LBF API}
  spec.description   = %q{Service objects for making requests to the LBF API and parsing its responses}
  spec.homepage      = "https://github.com/oversee-ffleming/lbf"
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.license       = 'MIT'

  spec.add_development_dependency "bundler", "~> 1.7"

  spec.add_runtime_dependency 'savon', '~> 2.10'
  spec.add_runtime_dependency 'rubyntlm', '0.3.2'
  spec.add_runtime_dependency 'activesupport', '~> 4.1'

end
