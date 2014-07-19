require 'jekyll'
require 'sass'
require 'uglifier'
require 'autoprefixer-rails'
require 'digest/md5'
require 'jekyll-page-hooks'
require 'octopress-tag-helpers'

require 'octopress-ink/version'

require 'octopress-ink/utils'
require 'octopress-ink/generators/plugin_assets'
require 'octopress-ink/jekyll/hooks'

module Octopress
  module Ink

    autoload :Configuration,        'octopress-ink/configuration'
    autoload :Filters,              'octopress-ink/filters'
    autoload :Assets,               'octopress-ink/assets'
    autoload :Page,                 'octopress-ink/jekyll/page'
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

    def self.config
      @config ||= Configuration.config
    end

    def self.site(options={})
      unless @site
        @site ||= init_site(options)
      end

      @site
    end

    def self.site=(site)
      # Octopress historically used site.title
      # This allows theme developers to expect site.name
      # in consistancy with Jekyll's scaffold config 
      site.config['name'] ||= site.config['title']

      @site = site
    end

    def self.payload(jekyll_payload={})
      Jekyll::Utils.deep_merge_hashes(jekyll_payload, custom_payload)
    end

    def self.custom_payload
      unless @custom_payload
        config = Plugins.config
        site_payload = Ink.site.site_payload
        site_payload['linkposts'] = self.linkposts
        site_payload['articles'] = self.articles

        payload = {
          'plugins'   => config['plugins'],
          'theme'     => config['theme'],
          'octopress' => {
            'version' => Octopress::Ink.version
          },
          'site' => site_payload
        }

        if Octopress::Ink.config['docs_mode']
          payload['doc_pages'] = Octopress::Ink::Plugins.doc_pages
        end

        @custom_payload = payload
      end

      @custom_payload
    end

    def self.linkposts
      @linkposts ||= site.posts.select {|p| p.data['linkpost']}
    end

    def self.articles
      @articles ||= site.posts.reject {|p| p.data['linkpost']}
    end

    def self.init_site(options)
      Jekyll.logger.log_level = :error
      site = Jekyll::Site.new(Jekyll.configuration(options))
      Jekyll.logger.log_level = :info
      site
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
      site(options)
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
      site(options)
      Plugins.register
      options.delete('config')
      if p = plugin(name)
        puts p.list(options)
      else
        not_found(name)
      end
    end

    def self.copy_plugin_assets(name, options)
      site(options)
      Plugins.register
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
        full_path = File.join(Ink.site.source, path)
        if !Dir["#{full_path}/*"].empty? && options['force'].nil?
          abort "Error: directory #{path} is not empty. Use --force to overwrite files."
        end
      else
        full_path = File.join(Ink.site.source, Plugins.custom_dir, name)
      end

      full_path
    end

    def self.list_plugins(options={})
      site(options)
      Plugins.register
      puts "\nCurrently installed plugins:"
      if plugins.size > 0
        plugins.each { |plugin| puts plugin.name }
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

Liquid::Template.register_filter Octopress::Ink::Filters

Liquid::Template.register_tag('css_asset_tag', Octopress::Ink::Tags::JavascriptTag)
Liquid::Template.register_tag('js_asset_tag', Octopress::Ink::Tags::StylesheetTag)
Liquid::Template.register_tag('doc_url', Octopress::Ink::Tags::DocUrlTag)

require 'octopress-ink/plugins/ink'

Octopress::Ink.register_plugin(Octopress::Ink::InkPlugin)
