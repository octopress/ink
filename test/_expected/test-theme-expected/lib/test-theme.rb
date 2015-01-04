require 'test-theme/version'
require 'octopress-ink'

Octopress::Ink.add_plugin({
  name:          "Test Theme",
  slug:          "theme",
  gem:           "test-theme",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "../")),
  type:          "theme",
  version:       TestTheme::VERSION,
  description:   "",                                # What does your theme/plugin do?
  source_url:    "https://github.com/user/project", # <- Update info
  website:       ""                                 # Optional project website
})
