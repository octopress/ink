# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-ink/version'

Gem::Specification.new do |spec|
  spec.name          = "octopress-ink"
  spec.version       = Octopress::Ink::VERSION
  spec.authors       = ["Brandon Mathis"]
  spec.email         = ["brandon@imathis.com"]
  spec.summary       = %q{A framework for creating themes and plugins for Jekyll sites}
  spec.homepage      = "https://github.com/octopress/ink"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").grep(/^(bin\/|lib\/|assets\/|demo\/|changelog|readme|license)/i)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  

  spec.add_runtime_dependency "jekyll", ">= 2.0"
  spec.add_runtime_dependency "uglifier", "~> 2.5"
  spec.add_runtime_dependency "octopress-hooks", "~> 2.2"
  spec.add_runtime_dependency "octopress-include-tag", "~> 1.0"
  spec.add_runtime_dependency "octopress-filters", "~> 1.1"
  spec.add_runtime_dependency "octopress-date-format", "~> 3.0"
  spec.add_runtime_dependency "octopress-autoprefixer", "~> 1.0"
  spec.add_runtime_dependency "octopress", "~> 3.0"

  spec.add_development_dependency "rake"
  spec.add_development_dependency "clash"
  spec.add_development_dependency "octopress-multilingual"
  spec.add_development_dependency "octopress-linkblog"

  if RUBY_VERSION >= "2"
    spec.add_development_dependency "bundler", "~> 1.7"
    spec.add_development_dependency "octopress-debugger"
  else
    spec.add_development_dependency "bundler", "~> 1.6"
  end
end
