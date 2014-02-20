require 'octopress-ink'

class TestTheme < Octopress::Ink::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__)))
    super
  end
  def add_assets
    add_stylesheets ['theme-test.css', 'theme-test2.css']
    add_stylesheet 'theme-media-test@print.css'
    add_sass 'main.scss'
    add_root_files ['favicon.ico', 'favicon.png']
  end
end

Octopress::Ink.register_plugin(TestTheme, 'classic', 'theme')
