require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:        "Blog Theme",
  type:        "theme",
  description: "Blog theme y'all",
  assets_path:  File.expand_path(File.dirname(__FILE__))
})
