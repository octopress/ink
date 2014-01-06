require 'jekyll'
require 'jekyll-page-hooks'
require 'pry-debugger'
require 'digest/md5'

require 'octopress-plugins/generators/plugin_assets'
require 'octopress-plugins/jekyll/hooks'
require 'octopress-plugins/version'
require 'octopress-plugins/helpers/content_for'

module Octopress
  CUSTOM_DIR = "_custom"

  autoload :Assets,               'octopress-plugins/assets'
  autoload :StaticFile,           'octopress-plugins/assets/static_file'
  autoload :StaticFileContent,    'octopress-plugins/assets/static_file_content'
  autoload :Plugins,              'octopress-plugins/plugins'
  autoload :Plugin,               'octopress-plugins/plugin'
  autoload :Tags,                 'octopress-plugins/tags'
  autoload :SassPlugin,           'octopress-plugins/plugins/sass'

  def self.register_plugin(plugin, name, type)
    Plugins.register_plugin(plugin, name, type)
  end
end

Liquid::Template.register_tag('embed', Octopress::Tags::EmbedTag)
Liquid::Template.register_tag('theme_js', Octopress::Tags::JavascriptTag)
Liquid::Template.register_tag('theme_css', Octopress::Tags::StylesheetTag)
Liquid::Template.register_tag('content_for', Octopress::Tags::ContentForBlock)
Liquid::Template.register_tag('head', Octopress::Tags::HeadBlock)
Liquid::Template.register_tag('footer', Octopress::Tags::FooterBlock)
Liquid::Template.register_tag('scripts', Octopress::Tags::ScriptsBlock)
Liquid::Template.register_tag('yield', Octopress::Tags::YieldTag)
Liquid::Template.register_tag('wrap_yield', Octopress::Tags::WrapYieldBlock)

Octopress.register_plugin(Octopress::SassPlugin, 'sass', 'local_plugin')

