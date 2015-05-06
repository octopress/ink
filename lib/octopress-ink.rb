require 'jekyll'
require 'sass'
require 'uglifier'
require 'digest/md5'
require 'octopress'
require 'octopress-hooks'
require 'octopress-filters'
require 'octopress-include-tag'
require 'octopress-autoprefixer'

require 'octopress-ink/version'
require 'octopress-ink/configuration'
require 'octopress-ink/jekyll/hooks'
require 'octopress-ink/tags/set_lang'
require 'octopress-ink/cache'

module Octopress
  module Ink
    extend self

    autoload :Utils,                'octopress-ink/utils'
    autoload :Assets,               'octopress-ink/assets'
    autoload :Convertible,          'octopress-ink/jekyll/convertible'
    autoload :Page,                 'octopress-ink/jekyll/page'
    autoload :Layout,               'octopress-ink/jekyll/layout'
    autoload :StaticFile,           'octopress-ink/jekyll/static_file'
    autoload :StaticFileContent,    'octopress-ink/jekyll/static_file_content'
    autoload :Plugins,              'octopress-ink/plugins'
    autoload :Plugin,               'octopress-ink/plugin'
    autoload :Bootstrap,            'octopress-ink/plugin/bootstrap'
    autoload :PluginAssetPipeline,  'octopress-ink/plugin_asset_pipeline'
    autoload :Tags,                 'octopress-ink/tags'

    if defined? Octopress::Command
      require 'octopress-ink/commands/helpers'
      require 'octopress-ink/commands'
    end

    @load_plugin_assets = true

    Plugins.reset

    def version
      version = "Jekyll v#{Jekyll::VERSION}, "
      if defined? Octopress::VERSION
        version << "Octopress v#{Octopress::VERSION} "
      end
      version << "Octopress Ink v#{Octopress::Ink::VERSION}"
    end

    def payload(lang=nil)
      config = Plugins.config(lang)
      ink_payload = {
        'plugins'   => config['plugins'],
        'theme'     => config['theme'],
        'octopress' => {
          'version' => version,
        }
      }

      ink_payload
    end

    def enabled?
      @load_plugin_assets
    end

    def load_plugin_assets=(setting)
      @load_plguin_assets = setting
    end

    # Register a new plugin
    # 
    # plugin - A subclass of Plugin
    #
    def register_plugin(plugin, options={})
      options[:type] ||= 'plugin'
      Plugins.register_plugin(plugin, options)
    end

    def register_theme(plugin, options={})
      options[:type] = 'theme'
      Plugins.register_plugin(plugin, options)
    end

    # Create a new plugin from a configuration hash
    # 
    # options - A hash of configuration options.
    #
    def add_plugin(options={})
      register_plugin Plugin, options
    end

    def add_theme(options={})
      register_theme Plugin, options
    end

    def add_docs(options={})
      Docs.register_docs options
    end

    def watch_assets(site)
      if site.config['ink_watch']
        require 'octopress-ink/watch'
      end
    end

    def config
      @config ||= Configuration.config
    end

    def plugins
      Plugins.plugins
    end

    def plugin(name)
      begin
        Plugins.plugin(name)
      rescue
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
    def list(options={})
      site = Octopress.site(options)
      Plugins.register
      options = {'minimal'=>true} if options.empty?
      message = "Octopress Ink - v#{VERSION}\n"

      if plugins.size > 0
        plugins.each do |plugin|
          message += plugin.list(options)
        end
      else
        message += "You have no plugins installed."
      end
      puts message
    end

    def plugin_list(name, options)
      config = options.delete('config') # Jekyll conflicts with this option
      Octopress.site(options)
      Octopress.site.read
      Plugins.register
      options['config'] = config if config

      if p = plugin(name)
        puts p.list(options)
      else
        not_found(name)
      end
    end

    def copy_plugin_assets(name, options)
      config = options.delete('config') # Jekyll conflicts with this option
      Octopress.site(options)
      Plugins.register
      options['config'] = config if config

      path = copy_path(name, options)

      if p = plugin(name)
        copied = p.copy_asset_files(path, options)
        if !copied.empty?
          puts "Copied files:\n#{copied.join("\n")}"
        else
          puts "No files copied from #{name}."
        end
      else
        not_found(name)
      end
    end

    def copy_path(name, options)
      if path = options.delete('path')
        full_path = File.join(Dir.pwd, path)
        if !Dir["#{full_path}/*"].empty? && options['force'].nil?
          abort "Error: directory #{path} is not empty. Use --force to overwrite files."
        end
      else
        full_path = File.join(Plugins.custom_dir, name)
      end

      full_path
    end

    def list_plugins(options={})
      Octopress.site(options)
      Plugins.register
      puts "\nCurrently installed plugins:"
      if plugins.size > 0
        plugins.each { |plugin| puts plugin.name + " (#{plugin.slug})" }
      else
        puts "You have no plugins installed."
      end
    end

    def gem_dir(*subdirs)
      File.expand_path(File.join(File.dirname(__FILE__), '../', *subdirs))
    end

    # Makes it easy for Ink plugins to copy README and CHANGELOG
    # files to doc folder to be used as a documentation asset file
    # 
    # Usage: In rakefile require 'octopress-ink'
    #        then add task calling Octopress::Ink.copy_doc for each file
    #
    def copy_doc(source, dest, permalink=nil)
      contents = File.open(source).read

      # Convert H1 to title and add permalink in YAML front-matter
      #
      contents.sub!(/^# (.*)$/, "#{doc_yaml('\1', permalink).strip}")

      FileUtils.mkdir_p File.dirname(dest)
      File.open(dest, 'w') {|f| f.write(contents) }
      puts "Updated #{dest} from #{source}"
    end

    private

    def not_found(plugin)
      puts "Plugin '#{plugin}' not found."
      list_plugins
    end

    def doc_yaml(title, permalink)
      yaml  = "---\n"
      yaml += "title: \"#{title.strip}\"\n"
      yaml += "permalink: #{permalink.strip}\n" if permalink
      yaml += "---"
    end
  end
end

Liquid::Template.register_tag('css_asset_tag', Octopress::Ink::Tags::StylesheetTag)
Liquid::Template.register_tag('js_asset_tag', Octopress::Ink::Tags::JavascriptTag)
Liquid::Template.register_tag('category_links', Octopress::Ink::Tags::CategoryTag)
Liquid::Template.register_tag('category_list', Octopress::Ink::Tags::CategoryTag)
Liquid::Template.register_tag('tag_links', Octopress::Ink::Tags::CategoryTag)
Liquid::Template.register_tag('tag_list', Octopress::Ink::Tags::CategoryTag)
Liquid::Template.register_tag('feeds', Octopress::Ink::Tags::FeedsTag)
Liquid::Template.register_tag('feed_updated', Octopress::Ink::Tags::FeedUpdatedTag)

Octopress::Docs.add({
  name:        "Octopress Ink",
  gem:         "octopress-ink",
  version:     Octopress::Ink::VERSION,
  description: "A framework for creating Jekyll quality themes and plugins",
  slug:        "ink",
  path:        File.expand_path(File.join(File.dirname(__FILE__), "../")),
  source_url:  "https://github.com/octopress/ink",
})
