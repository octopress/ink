require 'jekyll'
require 'jekyll-page-hooks'
require 'pry-debugger'
require 'digest/md5'

require 'octopress-plugins/generators/plugin_assets'
require 'octopress-plugins/version'

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
Liquid::Template.register_tag('do_layout', Octopress::Tags::DoLayoutTag)
Liquid::Template.register_tag('theme_js', Octopress::Tags::JavascriptTag)
Liquid::Template.register_tag('theme_css', Octopress::Tags::StylesheetTag)

Octopress.register_plugin(Octopress::SassPlugin, 'sass', 'local_plugin')

