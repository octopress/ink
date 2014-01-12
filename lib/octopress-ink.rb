require 'jekyll'
require 'sass'
require 'digest/md5'

require 'octopress-ink/version'
require 'octopress-ink/generators/plugin_assets'
require 'octopress-ink/jekyll/hooks'
require 'octopress-ink/version'
require 'octopress-ink/helpers/content_for'
require 'pry-debugger'

module Octopress
  CUSTOM_DIR = "_custom"

  autoload :Assets,               'octopress-ink/assets'
  autoload :StaticFile,           'octopress-ink/assets/static_file'
  autoload :StaticFileContent,    'octopress-ink/assets/static_file_content'
  autoload :Plugins,              'octopress-ink/plugins'
  autoload :Plugin,               'octopress-ink/plugin'
  autoload :Tags,                 'octopress-ink/tags'
  autoload :SassPlugin,           'octopress-ink/plugins/sass'
  autoload :CSSPlugin,            'octopress-ink/plugins/css'

  def self.register_plugin(plugin, name, type='plugin')
    Plugins.register_plugin(plugin, name, type)
  end
end

Liquid::Template.register_tag('include', Octopress::Tags::IncludeTag)
Liquid::Template.register_tag('octopress_js', Octopress::Tags::JavascriptTag)
Liquid::Template.register_tag('octopress_css', Octopress::Tags::StylesheetTag)
Liquid::Template.register_tag('content_for', Octopress::Tags::ContentForBlock)
Liquid::Template.register_tag('head', Octopress::Tags::HeadBlock)
Liquid::Template.register_tag('footer', Octopress::Tags::FooterBlock)
Liquid::Template.register_tag('scripts', Octopress::Tags::ScriptsBlock)
Liquid::Template.register_tag('yield', Octopress::Tags::YieldTag)
Liquid::Template.register_tag('wrap_yield', Octopress::Tags::WrapYieldBlock)

Octopress.register_plugin(Octopress::SassPlugin, 'sass', 'local_plugin')
Octopress.register_plugin(Octopress::CSSPlugin, 'css', 'local_plugin')

