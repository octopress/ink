begin
  require "bundler/setup"
  Bundler.require(:jekyll_plugins)
rescue LoadError
end

class ClassicTheme < ThemeKit::Theme
  def initialize(name)
    @assets_path = File.expand_path(File.dirname(__FILE__))
    super
  end

  def add_assets
    add_layouts
    add_stylesheets ['site.css','foo.css'], 'all'
    add_stylesheet 'print.css', 'print'
    add_javascripts ['foo.js', 'bar.js']
  end
end

ThemeKit::Plugins.register_theme(ClassicTheme)
