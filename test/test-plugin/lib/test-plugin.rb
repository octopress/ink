require 'test-plugin/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Test Plugin",
  slug:          "test-plugin",
  assets_path:   File.expand_path(File.join(File.dirname(__FILE__), "../assets")),
  type:          "plugin",
  version:       TestPlugin::VERSION,
  description:   "",
  website:       ""
})