class TestPlugin < Octopress::Ink::Plugin
  @config = {
    assets_path: File.expand_path(File.dirname(__FILE__)),
    description: "Test some plugins y'all",
    slug:        'awesome-sauce',
    name:        'Awesome Sauce'
  }
  def initialize
    super
  end

  def add_assets
    add_css 'plugin-test.css'
    add_css 'plugin-media-test.css', 'print'
    super
  end
end

Octopress::Ink.register_plugin(TestPlugin)

