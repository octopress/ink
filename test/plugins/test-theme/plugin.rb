require 'octopress-ink'

Octopress::Ink.new_plugin({
  name:        "Classic Theme",
  type:        "theme",
  description: "Test theme y'all",
  assets_path:  File.expand_path(File.dirname(__FILE__))
})
