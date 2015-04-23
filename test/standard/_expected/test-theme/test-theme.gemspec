# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'test-theme/version'

Gem::Specification.new do |spec|
  spec.name          = "test-theme"
  spec.version       = TestTheme::VERSION
  spec.authors       = ["TODO: Write your name"]
  spec.email         = ["TODO: Write your email address"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").grep(%r{^(bin/|lib/|assets/|changelog|readme|license)}i)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "clash"
  
  spec.add_runtime_dependency "octopress-ink", "~> 1.0"
end
