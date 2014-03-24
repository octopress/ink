require 'octopress-ink'

class TestPlugin < Octopress::Ink::Plugin
  def configuration
    {
      name:        'Awesome Sauce',
      slug:        'awesome-sauce',
      assets_path: File.expand_path(File.dirname(__FILE__)),
      description: "Test some plugins y'all"
    }
  end
end

Octopress::Ink.register_plugin(TestPlugin)

