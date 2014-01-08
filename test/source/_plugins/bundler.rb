require 'octopress-ink'

class ClassicTheme < Octopress::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__), 'theme'))
    super
  end

  def add_assets
    add_stylesheets ['site.css','foo.css'], 'all'
    add_stylesheet 'print.css', 'print'
    add_javascripts ['foo.js', 'bar.js']
    add_sass 'bar.scss'
    add_file 'test.html'
  end
end

Octopress.register_plugin(ClassicTheme, 'classic', 'theme')

