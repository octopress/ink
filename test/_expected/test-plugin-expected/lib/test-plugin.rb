require 'test-plugin/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Test Plugin",
  slug:          "test-plugin",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "../")),
  type:          "plugin",
  version:       TestPlugin::VERSION,
  description:   "",
  website:       ""
})
