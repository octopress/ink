require 'test-theme/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Test Theme",
  slug:          "test-theme",
  assets_path:   File.expand_path(File.join(File.dirname(__FILE__), "../assets")),
  type:          "theme",
  version:       TestTheme::VERSION,
  description:   "",
  website:       ""
})