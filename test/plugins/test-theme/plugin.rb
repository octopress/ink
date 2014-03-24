require 'octopress-ink'

class TestTheme < Octopress::Ink::Plugin
  def configuration
    {
      type:        "theme",
      description: "Test theme y'all",
      name:        "Classic Theme",
      assets_path:  File.expand_path(File.dirname(__FILE__))
    }
  end
end

Octopress::Ink.register_plugin(TestTheme)
