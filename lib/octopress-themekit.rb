require 'jekyll'
require 'jekyll-page-hooks'

require 'octopress-themekit/generators/stylesheets'
require 'octopress-themekit/generators/javascripts'

module ThemeKit
  THEME_DIR = "_theme"

  autoload :Asset,         'octopress-themekit/asset'
  autoload :Theme,         'octopress-themekit/theme'
  autoload :Template,      'octopress-themekit/template'
  autoload :Stylesheet,    'octopress-themekit/stylesheet'
  autoload :Javascript,    'octopress-themekit/javascript'
  autoload :LayoutTag,     'octopress-themekit/tags/layout'
  autoload :DoLayoutTag,   'octopress-themekit/tags/do_layout'
  autoload :JavascriptTag, 'octopress-themekit/tags/javascript'
  autoload :StylesheetTag, 'octopress-themekit/tags/stylesheet'
end

Liquid::Template.register_tag('layout', ThemeKit::LayoutTag)
Liquid::Template.register_tag('do_layout', ThemeKit::DoLayoutTag)
Liquid::Template.register_tag('theme_js', ThemeKit::JavascriptTag)
Liquid::Template.register_tag('theme_css', ThemeKit::StylesheetTag)
