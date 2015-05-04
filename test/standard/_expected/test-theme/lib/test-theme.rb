require 'test-theme/version'
require 'octopress-ink'

Octopress::Ink.add_theme({
  name:          "Test Theme",
  slug:          "theme",
  gem:           "test-theme",
  path:          File.expand_path(File.join(File.dirname(__FILE__), "..")),
  version:       TestTheme::VERSION,
  description:   "",                                # What does your theme/plugin do?
  source_url:    "https://github.com/user/project", # <- Update info
  website:       ""                                 # Optional project website
})
