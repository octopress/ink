require 'jekyll'
require 'sass'
require 'uglifier'
require 'digest/md5'
require 'octopress'
require 'octopress-hooks'
require 'octopress-filters'
require 'octopress-docs'

require 'octopress-ink/version'
require 'octopress-ink/configuration'
require 'octopress-ink/jekyll/hooks'

module Octopress
  def self.site=(site)
    # Octopress historically used site.title
    # This allows theme developers to expect site.name
    # in consistancy with Jekyll's scaffold config 
    
    site.config['name'] ||= site.config['title']

    @site = site
  end

  module Ink

    autoload :Assets,               'octopress-ink/assets'
    autoload :Convertible,          'octopress-ink/jekyll/convertible'
    autoload :Page,                 'octopress-ink/jekyll/page'
    autoload :Layout,               'octopress-ink/jekyll/layout'
    autoload :StaticFile,           'octopress-ink/jekyll/static_file'
    autoload :StaticFileContent,    'octopress-ink/jekyll/static_file_content'
    autoload :Plugins,              'octopress-ink/plugins'
    autoload :Plugin,               'octopress-ink/plugin'
    autoload :PluginAssetPipeline,  'octopress-ink/plugin_asset_pipeline'
    autoload :Tags,                 'octopress-ink/tags'

    if defined? Octopress::Command
      require 'octopress-ink/commands/helpers'
      require 'octopress-ink/commands'
    end

    def self.version
      version = "Jekyll v#{Jekyll::VERSION}, "
      if defined? Octopress::VERSION
        version << "Octopress v#{Octopress::VERSION} "
      end
      version << "Octopress Ink v#{Octopress::Ink::VERSION}"
    end

    def self.payload
      config = Plugins.config
      ink_payload = {
        'plugins'   => config['plugins'],
        'theme'     => config['theme'],
        'octopress' => {
          'version' => version
        }
      }

      ink_payload
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

    def self.add_docs(options={})
      Docs.register_docs options
    end

    def self.config
      @config ||= Configuration.config
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
      Octopress.site(options)
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

    def self.plugin_list(name, options)
      config = options.delete('config') # Jekyll conflicts with this option
      Octopress.site(options)
      Plugins.register
      options['config'] = config if config

      if p = plugin(name)
        puts p.list(options)
      else
        not_found(name)
      end
    end

    def self.copy_plugin_assets(name, options)
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

    def self.copy_path(name, options)
      if path = options.delete('path')
        full_path = File.join(Dir.pwd, path)
        if !Dir["#{full_path}/*"].empty? && options['force'].nil?
          abort "Error: directory #{path} is not empty. Use --force to overwrite files."
        end
      else
        full_path = File.join(Dir.pwd, Plugins.custom_dir, name)
      end

      full_path
    end

    def self.list_plugins(options={})
      Octopress.site(options)
      Plugins.register
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

    # Makes it easy for Ink plugins to copy README and CHANGELOG
    # files to doc folder to be used as a documentation asset file
    # 
    # Usage: In rakefile require 'octopress-ink'
    #        then add task calling Octopress::Ink.copy_doc for each file
    #
    def self.copy_doc(source, dest, permalink=nil)
      contents = File.open(source).read

      # Convert H1 to title and add permalink in YAML front-matter
      #
      contents.sub!(/^# (.*)$/, "#{doc_yaml('\1', permalink).strip}")

      FileUtils.mkdir_p File.dirname(dest)
      File.open(dest, 'w') {|f| f.write(contents) }
      puts "Updated #{dest} from #{source}"
    end

    private

    def self.not_found(plugin)
      puts "Plugin '#{plugin}' not found."
      list_plugins
    end

    def self.doc_yaml(title, permalink)
      yaml  = "---\n"
      yaml += "title: \"#{title.strip}\"\n"
      yaml += "permalink: #{permalink.strip}\n" if permalink
      yaml += "---"
    end
  end
end

Liquid::Template.register_tag('css_asset_tag', Octopress::Ink::Tags::StylesheetTag)
Liquid::Template.register_tag('js_asset_tag', Octopress::Ink::Tags::JavascriptTag)

Octopress::Docs.add({
  name:        "Octopress Ink",
  slug:        "ink",
  dir:         File.expand_path(File.join(File.dirname(__FILE__), "../")),
  base_url:    "docs/ink"
})
