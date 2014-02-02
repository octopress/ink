class TestPlugin < Octopress::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__)))
    super
  end

  def add_assets
    add_stylesheet 'plugin-test.css'
    add_stylesheet 'plugin-media-test.css', 'print'
    add_root_file 'robots.txt'
    super
  end
end

Octopress.register_plugin(TestPlugin, 'awesome-sauce')

