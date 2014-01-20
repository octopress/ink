require 'octopress-ink'

class TestTheme < Octopress::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__), 'test-theme'))
    super
  end
  def add_assets
    add_stylesheets ['theme-test.css', 'theme-test2.css']
    add_stylesheet 'theme-media-test@print.css'
    add_sass 'main.scss'
    add_root_files ['favicon.ico', 'favicon.png']
  end
end

class TestPlugin < Octopress::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__), 'awesome-sauce'))
    super
  end

  def add_assets
    add_stylesheet 'plugin-test.css'
    add_stylesheet 'plugin-media-test.css', 'print'
    add_root_file 'robots.txt'
    super
  end
end

Octopress.register_plugin(TestTheme, 'classic', 'theme')
Octopress.register_plugin(TestPlugin, 'awesome-sauce')

