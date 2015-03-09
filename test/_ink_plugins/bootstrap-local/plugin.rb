require 'octopress-ink'
Octopress::Ink.add_plugin({
  name:        "Bootstrap Local",
  description: "Bootstrap local layouts",
  path:         File.expand_path(File.dirname(__FILE__)),
  local: true
})
