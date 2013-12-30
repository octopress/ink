begin
  require "bundler/setup"
  Bundler.require(:jekyll_plugins)
rescue LoadError
end

class ClassicTheme < ThemeKit::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.dirname(__FILE__))
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

ThemeKit::Plugins.register_plugin(ClassicTheme, 'classic', 'theme')

class SassPlugin < ThemeKit::Plugin
  def initialize(name, type)
    @assets_path = File.expand_path(File.join(File.dirname(__FILE__), '../'))
    super
  end

  def add_assets
    add_sass 'site.scss'
  end
end

ThemeKit::Plugins.register_plugin(SassPlugin, 'sass', 'local_plugin')
