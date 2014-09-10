require 'test-theme/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Test Theme",
  slug:          "theme",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "../")),
  type:          "theme",
  version:       TestTheme::VERSION,
  description:   "",
  website:       ""
})