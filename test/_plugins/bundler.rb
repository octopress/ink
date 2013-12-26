begin
  require "bundler/setup"
  Bundler.require(:jekyll_plugins)
rescue LoadError
end

class ClassicTheme < ThemeKit::Theme
  def initialize
    @assets_path = File.expand_path(File.join(__FILE__, '../../../assets'))
    super
  end

  def add_assets
    add_layouts
    add_stylesheet 'site.css', 'screen'
    add_javascript 'foo.js'
  end
end

ThemeKit::Template.register_theme('classic', ClassicTheme)
