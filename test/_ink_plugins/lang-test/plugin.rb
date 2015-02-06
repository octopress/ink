require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:        'Lang Test',
  path:         File.expand_path(File.dirname(__FILE__)),
  description: "Testing language configurations."
})
