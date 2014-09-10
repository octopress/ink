require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:        'Awesome Sauce',
  slug:        'awesome-sauce',
  path:         File.expand_path(File.dirname(__FILE__)),
  description: "Test some plugins y'all"
})
