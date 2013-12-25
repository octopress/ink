begin
  require "bundler/setup"
  Bundler.require(:jekyll_plugins)
rescue LoadError
end

class ClassicTheme < ThemeKit::Theme
  def add_assets
    add_assets_path File.expand_path(File.join(__FILE__, '../../../assets'))
    add_stylesheet 'site.css'
    add_javascript 'foo.js'
  end
end

ThemeKit::Template.register_theme('classic', ClassicTheme)
