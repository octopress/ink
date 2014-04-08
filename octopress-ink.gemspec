# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-ink/version'

Gem::Specification.new do |spec|
  spec.name          = "octopress-ink"
  spec.version       = Octopress::Ink::VERSION
  spec.authors       = ["Brandon Mathis"]
  spec.email         = ["brandon@imathis.com"]
  spec.description   = %q{A starting point for creating gem-based Jekyll themes and plugins}
  spec.summary       = %q{A starting point for creating gem-based Jekyll themes and plugins}
  spec.homepage      = "https://github.com/octopress/ink"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "jekyll", "~> 1.5", ">= 1.5.1"
  spec.add_runtime_dependency "sass", "~> 3.3.4"
  spec.add_runtime_dependency "autoprefixer-rails", "~> 1.1", ">= 1.1.20140403"

  spec.add_development_dependency "octopress"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry-debugger"
end
