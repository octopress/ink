require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:        "Classic Theme",
  type:        "theme",
  description: "Test theme y'all",
  path:         File.expand_path(File.dirname(__FILE__)),
})
