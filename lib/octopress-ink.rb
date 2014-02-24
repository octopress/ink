require 'jekyll'
require 'sass'
require 'digest/md5'

require 'octopress-ink/version'
require 'octopress-ink/generators/plugin_assets'
require 'octopress-ink/jekyll/hooks'
require 'octopress-ink/version'
require 'octopress-ink/helpers/titlecase'

module Octopress
  module Ink
    autoload :Helpers,              'octopress-ink/helpers'
    autoload :Filters,              'octopress-ink/filters'
    autoload :Assets,               'octopress-ink/assets'
    autoload :Page,                 'octopress-ink/jekyll/page'
    autoload :StaticFile,           'octopress-ink/jekyll/static_file'
    autoload :StaticFileContent,    'octopress-ink/jekyll/static_file_content'
    autoload :Plugins,              'octopress-ink/plugins'
    autoload :Plugin,               'octopress-ink/plugin'
    autoload :Tags,                 'octopress-ink/tags'
    autoload :StylesheetsPlugin,    'octopress-ink/plugins/stylesheets'

    if defined? Octopress::Command
      require 'octopress-ink/commands/helpers'
      require 'octopress-ink/commands'
    end

    def self.register_plugin(plugin, name, type='plugin')
      Plugins.register_plugin(plugin, name, type)
    end

    def self.version
      version = "Jekyll v#{Jekyll::VERSION}, "
      if defined? Octopress::VERSION
        version << "Octopress v#{Octopress::VERSION} "
      end
      version << "Octopress Ink v#{Octopress::Ink::VERSION}"
    end

    def self.site(options={})
      log_level = Jekyll.logger.log_level
      Jekyll.logger.log_level = Jekyll::Stevenson::WARN
      @site ||= Jekyll::Site.new(Jekyll.configuration(options))
      Jekyll.logger.log_level = log_level
      @site
    end

    def self.plugins
      Plugins.plugins
    end

    def self.plugin(name)
      begin
        Plugins.plugin(name)
      rescue
        return false
      end
    end

    def self.plugin_info(name, options)
      Plugins.register site(options)
      options.delete('config')
      if p = plugin(name)
        p.info(options)
      end
    end
    
    def self.info(options={})
      Plugins.register site(options)
      options.delete('config')
      message = "Octopress Ink - v#{VERSION}\n"
      if plugins.size > 0
        options['brief'] = options.empty?
        plugins.each do |plugin|
          message += plugin.info(options)
        end
      else
        message += "Plugins: none"
      end
      puts message
    end
  end
end

Liquid::Template.register_filter Octopress::Ink::Filters

Liquid::Template.register_tag('include', Octopress::Ink::Tags::IncludeTag)
Liquid::Template.register_tag('assign', Octopress::Ink::Tags::AssignTag)
Liquid::Template.register_tag('capture', Octopress::Ink::Tags::CaptureTag)
Liquid::Template.register_tag('return', Octopress::Ink::Tags::ReturnTag)
Liquid::Template.register_tag('filter', Octopress::Ink::Tags::FilterTag)
Liquid::Template.register_tag('render', Octopress::Ink::Tags::RenderTag)
Liquid::Template.register_tag('octopress_js', Octopress::Ink::Tags::JavascriptTag)
Liquid::Template.register_tag('octopress_css', Octopress::Ink::Tags::StylesheetTag)
Liquid::Template.register_tag('content_for', Octopress::Ink::Tags::ContentForTag)
Liquid::Template.register_tag('yield', Octopress::Ink::Tags::YieldTag)
Liquid::Template.register_tag('wrap', Octopress::Ink::Tags::WrapTag)
Liquid::Template.register_tag('abort', Octopress::Ink::Tags::AbortTag)
Liquid::Template.register_tag('_', Octopress::Ink::Tags::LineCommentTag)

Octopress::Ink.register_plugin(Octopress::Ink::StylesheetsPlugin, 'user stylesheets', 'local_plugin')

