require 'jekyll'
require 'sass'
require 'autoprefixer-rails'
require 'digest/md5'

require 'octopress-ink/version'

require 'octopress-ink/ext/titlecase'
require 'octopress-ink/ext/hash'
require 'octopress-ink/generators/plugin_assets'
require 'octopress-ink/jekyll/hooks'
require 'octopress-ink/version'

module Octopress
  module Ink

    autoload :Configuration,        'octopress-ink/configuration'
    autoload :Helpers,              'octopress-ink/helpers'
    autoload :Filters,              'octopress-ink/filters'
    autoload :Assets,               'octopress-ink/assets'
    autoload :Page,                 'octopress-ink/jekyll/page'
    autoload :StaticFile,           'octopress-ink/jekyll/static_file'
    autoload :StaticFileContent,    'octopress-ink/jekyll/static_file_content'
    autoload :Plugins,              'octopress-ink/plugins'
    autoload :Plugin,               'octopress-ink/plugin'
    autoload :AssetPipeline,        'octopress-ink/asset_pipeline'
    autoload :Tags,                 'octopress-ink/tags'

    if defined? Octopress::Command
      require 'octopress-ink/commands/helpers'
      require 'octopress-ink/commands'
    end

    # Register a new plugin
    # 
    # plugin - A subclass of Plugin
    #
    def self.register_plugin(plugin)
      Plugins.register_plugin(plugin)
    end

    # Create a new plugin from a configuration hash
    # 
    # options - A hash of configuration options.
    #
    def self.add_plugin(options={})
      Plugins.register_plugin Plugin, options
    end

    def self.version
      version = "Jekyll v#{Jekyll::VERSION}, "
      if defined? Octopress::VERSION
        version << "Octopress v#{Octopress::VERSION} "
      end
      version << "Octopress Ink v#{Octopress::Ink::VERSION}"
    end

    def self.config
      Configuration.config
    end

    def self.site(options={})
      log_level = Jekyll.logger.log_level
      Jekyll.logger.log_level = Jekyll::Stevenson::ERROR
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

    # Prints a list of plugins and details
    #
    # options - a Hash of options from the `list` command
    #
    #   Note: if options are empty, this will display a
    #   list of plugin names, slugs, versions, and descriptions,
    #   but no assets, i.e. 'minimal' info.
    #
    #
    def self.list(options={})
      Plugins.register site(options)
      options = {'minimal'=>true} if options.empty?
      message = "Octopress Ink - v#{VERSION}\n"

      if plugins.size > 0
        plugins.each do |plugin|
          message += plugin.info(options)
        end
      else
        message += "You have no plugins installed."
      end
      puts message
    end

    def self.plugin_info(name, options)
      config = options.delete('config') # Jekyll conflicts with this option
      Plugins.register site(options)
      options['config'] = config if config

      if p = plugin(name)
        puts p.info(options)
      else
        not_found(name)
      end
    end

    def self.copy_plugin_assets(name, options)
      config = options.delete('config') # Jekyll conflicts with this option
      Plugins.register site(options)
      options['config'] = config if config

      if path = options.delete('path')
        full_path = File.join(Plugins.site.source, path)
        if !Dir["#{full_path}/*"].empty? && options['force'].nil?
          abort "Error: directory #{path} is not empty. Use --force to overwrite files."
        end
      else
        full_path = File.join(Plugins.site.source, Plugins.custom_dir, name)
      end
      
      if p = plugin(name)
        copied = p.copy_asset_files(full_path, options)
        if !copied.empty?
          puts "Copied files:\n#{copied.join("\n")}"
        else
          puts "No files copied from #{name}."
        end
      else
        not_found(name)
      end
    end

    def self.not_found(plugin)
      puts "Plugin '#{plugin}' not found."
      list_plugins
    end

    def self.list_plugins(options={})
      Plugins.register site(options)
      puts "\nCurrently installed plugins:"
      if plugins.size > 0
        plugins.each { |plugin| puts plugin.name + " (#{plugin.slug})" }
      else
        puts "You have no plugins installed."
      end
    end

    def self.gem_dir(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), '../', *subdirs))
    end

    def self.copy_doc(source, dest, permalink=nil)
      contents = File.open(source).read
      contents.sub!(/^# (.*)$/, "#{doc_yaml('\1', permalink).strip}")
      FileUtils.mkdir_p File.dirname(dest)
      File.open(dest, 'w') {|f| f.write(contents) }
      puts "Updated #{dest} from #{source}"
    end

    def self.doc_yaml(title, permalink)
      yaml  = "---\n"
      yaml += "title: \"#{title.strip}\"\n"
      yaml += "permalink: #{permalink.strip}\n" if permalink
      yaml += "---"
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
Liquid::Template.register_tag('doc_url', Octopress::Ink::Tags::DocUrlTag)

require 'octopress-ink/plugins/ink'
require 'octopress-ink/plugins/local_asset_pipeline'

Octopress::Ink.register_plugin(Octopress::Ink::InkPlugin)
Octopress::Ink.register_plugin(Octopress::Ink::AssetPipelinePlugin)

