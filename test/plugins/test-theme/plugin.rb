require 'octopress-ink'

class TestTheme < Octopress::Ink::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__)))
    @description = "Test theme y'all"
    super
  end
  def add_assets
    add_stylesheets ['theme-test.css', 'theme-test2.css']
    add_stylesheet 'theme-media-test@print.css'
    add_stylesheet 'disable-this.css'
    add_sass_files ['main.scss', 'disable.sass']
    add_root_files ['favicon.ico', 'favicon.png', 'disabled-file.txt']
    add_fonts ['font-one.otf', 'font-two.ttf']
    add_javascripts ['bar.js', 'foo.js', 'disable-this.js']
  end
end

Octopress::Ink.register_plugin(TestTheme, 'classic', 'theme')
