# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'playback/version'

Gem::Specification.new do |spec|
  spec.name          = "playback"
  spec.version       = Playback::VERSION
  spec.authors       = ["Yuichi Takada"]
  spec.email         = ["takadyuichi@gmail.com"]
  spec.summary       = "Execute http request from apache access log"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/takady/playback"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_dependency "apache_log-parser", "3.1.0"
end
