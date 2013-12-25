require 'jekyll'
require 'jekyll-page-hooks'
require 'pry-debugger'
require 'octopress-themekit/tags/layout'
require 'octopress-themekit/tags/javascript'
require 'octopress-themekit/tags/stylesheet'
require 'octopress-themekit/generators/stylesheets'
require 'octopress-themekit/generators/javascripts'

module ThemeKit
  autoload :Stylesheet,    'octopress-themekit/stylesheet'
  autoload :Theme,         'octopress-themekit/theme'
  class Template
    class << self
      attr_accessor :theme
    end

    def initialize
      @plugins = {}
    end

    def self.register_theme(name, theme)
      @theme = theme.new()
    end
    
    def self.register_plugin(name, plugin)
      @plugins[name] = plugin.new()
    end

    def self.all_stylesheets
      css = []
      plugins.each do |plugin| 
        css.concat plugin.stylesheets
      end
      css
    end
  end
end

Liquid::Template.register_tag('layout', ThemeKit::LayoutTag)
Liquid::Template.register_tag('do_layout', ThemeKit::DoLayoutTag)
Liquid::Template.register_tag('theme_js', ThemeKit::JavascriptTag)
Liquid::Template.register_tag('theme_css', ThemeKit::StylesheetTag)
