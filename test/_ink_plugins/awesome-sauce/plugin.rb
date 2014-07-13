require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:        'Awesome Sauce',
  slug:        'awesome-sauce',
  assets_path: File.expand_path(File.dirname(__FILE__)),
  description: "Test some plugins y'all"
})
