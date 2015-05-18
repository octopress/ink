require 'find'

module Octopress
  module Ink
    class Plugin

      include Bootstrap

      DEFAULT_CONFIG = {
        type: 'plugin',
        bootstrap: true
      }

      attr_reader   :name, :type, :path, :assets_path, :local, :website, :description, :gem, :version, :source_url, :website, :bootstrap,
                    :layouts_dir, :stylesheets_dir, :javascripts_dir, :files_dir, :includes_dir, :images_dir, :templates_dir,
                    :layouts, :includes, :images, :fonts, :files, :pages, :templates, :docs

      def initialize(options)
        @options = Jekyll::Utils.symbolize_hash_keys(options || configuration)

        DEFAULT_CONFIG.merge(options).each { |k,v| set_config(k,v) }

        @layouts_dir       = 'layouts'
        @files_dir         = 'files'
        @pages_dir         = 'pages'
        @docs_dir          = 'docs'
        @fonts_dir         = 'fonts'
        @images_dir        = 'images'
        @includes_dir      = 'includes'
        @javascripts_dir   = 'javascripts'
        @stylesheets_dir   = 'stylesheets'
        @templates_dir     = 'templates'
        @slug            ||= @name
        @assets_path     ||= File.join(@path, 'assets')
      end

      def reset
        @lang_configs      = []
        @layouts           = []
        @includes          = []
        @css               = []
        @js                = []
        @no_compress_js    = []
        @coffee            = []
        @images            = []
        @sass              = []
        @fonts             = []
        @files             = []
        @pages             = []
        @templates         = []
      end

      def register
        reset
        unless @assets_path.nil?
          disable_assets
          add_assets
          add_images

          if Octopress::Docs.enabled?
            add_docs
          end

          if Octopress::Ink.enabled?
            add_includes
            add_layouts
            add_javascripts
            add_stylesheets
            add_fonts
            add_files
            add_pages
            add_templates
            bootstrap_plugin if @bootstrap
          end
        end
      end

      # Themes should always have the slug "theme"
      #
      def slug
        Filters.sluggify @type == 'theme' ? 'theme' : @slug
      end

      # List info about plugin's assets
      #
      # returs: String filled with asset info
      #
      def list(options={})
        if options['minimal']
          minimal_list
        else
          detailed_list(options)
        end
      end

      # Add asset files which aren't disabled
      #
      def add_asset_files(options)
        select_assets(options).each do |name, assets|
          next if name == 'config-file'
          assets.each {|file| file.add unless file.disabled? }
        end
      end

      # Plugin authors override with template page adding
      #
      def add_template_pages; end

      # Copy asset files to plugin override path
      #
      def copy_asset_files(path, options)
        copied = []

        select_assets(options).each do |name, assets|
          next if name == 'user-lang-configs'
          assets.each { |a| copied << a.copy(path) }
        end

        copied.compact
      end

      def sort(files, config)
        sorted = []
        config.each do |item|
          files.each do |file|
            sorted << files.delete(file) if file.path.to_s.include? item
          end
        end

        sorted.concat files
      end

      # stylesheets should include Sass and CSS
      #
      def stylesheets
        sort(css.clone.concat(sass_without_partials), config['order_css'] || [])
      end

      def javascripts
        sort(js.clone.concat(coffee), config['order_js'] || [])
      end

      def no_compress_js
        @no_compress_js.reject(&:disabled?).compact
      end

      def user_plugin_dir
        File.join(Plugins.custom_dir, slug)
      end

      # Plugin configuration
      #
      # returns: Hash of merged user and default config.yml files
      #
      def config(lang=nil)
        if lang
          lang_config_hash[lang] || read_config
        else
          read_config
        end
      end

      def read_config
        @config ||= configs.first.read
      end

      # Language configurations
      #
      # returns: Hash of configs for files matching: conifg_[lang].yml
      #
      #   Example:
      #   { 
      #     'de' => { configs },
      #     'fr' => { configs }
      #   }
      #
      def lang_config_hash
        @lang_config_hash ||= begin 
          configs = {}

          user_lang_configs.each do |lang, file|
            configs[lang] = Jekyll::Utils.deep_merge_hashes(config, SafeYAML.load_file(file))
          end

          plugin_lang_configs.each do |lang, file|
            # Add to lang
            @lang_configs << Assets::LangConfig.new(self, File.basename(file), lang)
            configs[lang] = Jekyll::Utils.deep_merge_hashes(config, @lang_configs.last.read)
          end

          configs
        end
      end

      def plugin_lang_configs
        lang_config_files(@assets_path)
      end

      def user_lang_configs
        files = lang_config_files(user_plugin_dir)
        plugin_lang_configs.keys.each {|k| files.delete(k)}
        files
      end

      def lang_config_files(dir)
        configs = {}
        if defined?(Octopress::Multilingual) && Octopress.site.config['lang']
          files = Dir[File.join(dir, 'config_*.yml')]
          files.each do |file|
            # Determine the language from the filename pattern: conifg_[lang].yml
            lang = File.basename(file, '.*').split('_').last
            configs[lang] = file
          end
        end
        configs
      end

      # Remove files from Jekyll since they'll be proccessed by Ink instead
      #
      def remove_jekyll_assets(files)
        files.each {|f| f.remove_jekyll_asset }
      end

      def include(file)
        Pathname.new(@includes.find{|i| i.filename == file }.path)
      end

      def find_page(path)
        @pages.find {|page| page.filename == path }
      end

      private

      def get_paths(files)
        files.dup.map { |f| f.path }.compact
      end

      def disable_assets
        disabled = []
        config['disable'] ||= {}
        config['disable'].each do |key,val|
          next unless can_disable.include? key
          if !!val == val
            disabled << key if val
          elsif val.is_a? Array
            val.each { |v| disabled << File.join(key, v) }
          elsif val.is_a? String
            disabled << File.join(key, val)
          end
        end
        config['disable'] = disabled
      end

      def can_disable
        [
          'pages',
          'templates',
          'sass',
          'css',
          'stylesheets',
          'javascripts',
          'js',
          'coffee',
          'images',
          'fonts',
          'files'
        ]
      end

      def assets
        {
          'layouts'      => @layouts,
          'includes'     => @includes,
          'templates'    => @templates,
          'pages'        => @pages,
          'sass'         => @sass,
          'css'          => @css,
          'js'           => @js,
          'minjs'        => @no_compress_js,
          'coffee'       => @coffee,
          'images'       => @images,
          'fonts'        => @fonts,
          'files'        => @files,
          'config-file'  => @configs,
          'lang-configs' => @lang_configs
        }
      end

      # Return information about each asset
      def assets_list(options)
        message = ''
        no_assets = []

        select_assets(options).each do |name, assets|
          next if assets.compact.size == 0

          case name
          when 'pages'
            header = "pages:".ljust(36).bold + "urls"
            message << asset_list(assets.sort_by(&:file), header)
          when 'config-file'
            message << " config:\n".bold
            message << Ink::Utils.pretty_print_yaml(@config)
            message << "\n"

            lang_config_hash.keys.each do |lang|
              message << "\n"
              message << " config_#{lang}:\n".bold
              message << Ink::Utils.pretty_print_yaml(config(lang))
            end

          # Lang configs are listed above with the config hash, ensuring
          # that user configured files can be listed even if the plugin 
          # does not ship with alternate language config files
          #
          when 'lang-configs'; next
          else
            message << asset_list(assets, name)
          end

          message << "\n"
        end

        message
      end

      def asset_list(assets, heading)
        list = " #{heading}:\n".bold
        assets.each do |asset|
          list << "#{asset.info.rstrip}\n"
        end

        list
      end

      def minimal_list
        message = "#{@name.bold}"
        message += ", v#{@version}" if @version
        message += " (slug: #{slug})"
        if @description && !@description.empty?
          message = %Q{\n  #{message.ljust(30)}\n    "#{@description}"}
        end
        message += "\n"
      end

      def detailed_list(options)
        list = assets_list(options)
        return '' if list.empty?

        name = "Plugin: #{@name.bold}"
        name += " (theme)" if @type == 'theme'
        name += " - v#{@version}" if @version
        name  = name
        message = name
        message += "\nSlug: #{slug}"

        if @website && !@website.empty?
          message += "\n#{@website}"
        end

        if @description && !@description.empty?
          message += %Q{\n"#{@description}"}
        end

        lines = ''
        80.times { lines += '=' }

        message = "\n#{message}\n#{lines}\n"
        message += list
        message += "\n"
      end

      def pad_line(line)
        line = "| #{line.ljust(76)} |"
      end

      # Return selected assets
      #
      # input: options (an array ['type',...], hash {'type'=>true}
      # or string of asset types)
      #
      # Output a hash of assets instances {'files' => @files }
      #
      def select_assets(asset_types)

        # Accept options from the CLI (as a hash of asset_name: true)
        # Or from Ink modules as an array of asset names
        #
        if asset_types.is_a? Hash

          # Show Sass and CSS when 'stylesheets' is chosen
          if asset_types['stylesheets']
            asset_types['css'] = true
            asset_types['sass'] = true
            asset_types.delete('stylesheets')
          end

          if asset_types['javascripts']
            asset_types['js'] = true
            asset_types['minjs'] = true
            asset_types['coffee'] = true
            asset_types.delete('javascripts')
          end

          asset_types = asset_types.keys
        end

        # Args should allow a single asset as a string too
        #
        if asset_types.is_a? String
          asset_types = [asset_types]
        end

        # Match asset_types against list of assets and
        # remove asset_types which don't belong
        #
        asset_types.select!{|asset| assets.include?(asset)}

        # If there are no asset_types, return all assets
        # This will happen if list command is used with
        # no filtering arguments
        #
        if asset_types.nil? || asset_types.empty?
          assets
        else
          assets.select{|k,v| asset_types.include?(k)}
        end
      end

      def configs
        @configs ||= [Assets::Config.new(self, 'config.yml')]
      end

      def add_stylesheets
        find_assets(@stylesheets_dir).each do |asset|
          if File.extname(asset) =~ /s[ca]ss/
            @sass << Assets::Sass.new(self, @stylesheets_dir, asset)
          else
            @css << Assets::Stylesheet.new(self, @stylesheets_dir, asset)
          end
        end
      end

      def add_layouts
        @layouts = add_new_assets(@layouts_dir, Assets::Layout)
      end

      def add_includes
        @includes = add_new_assets(@includes_dir, Assets::Asset)
      end

      def add_pages
        @pages = add_new_assets(@pages_dir, Assets::PageAsset)
      end

      def add_templates
        @templates = add_new_assets(@templates_dir, Assets::Template)
        add_template_pages
      end

      def add_template_page(template, data={})
        template = find_template(template) if template.is_a? String
        unless template.nil?
          page = template.new_page(data)
          Octopress.site.pages << page
          page
        end
      end

      def find_template(file)
        @templates.find { |t| t.filename == file }
      end

      def add_docs
        Octopress::Docs.add_plugin_docs(self)
      end

      def add_files
        @files = add_new_assets(@files_dir, Assets::FileAsset)
      end

      def add_javascripts
        find_assets(@javascripts_dir).each do |asset|
          if asset.end_with?('js')
            @js << Assets::Javascript.new(self, @javascripts_dir, asset)
          elsif asset.end_with?('coffee')
            @coffee << Assets::Coffeescript.new(self, @javascripts_dir, asset)
          end
        end
      end

      def add_fonts
        @fonts = add_new_assets(@fonts_dir, Assets::Asset)
      end

      def add_images
        @images = add_new_assets(@images_dir, Assets::Asset)
      end

      def add_new_assets(dir, asset_type)
        find_assets(dir).map do |asset|
          asset_type.new(self, dir, asset)
        end
      end

      def find_assets(dir)
        full_dir = File.join(@assets_path, dir)
        glob_assets(full_dir).map do |file|
          file.sub(File.join(full_dir, ''), '')
        end
      end

      def glob_assets(dir)
        return [] unless Dir.exist? dir
        Find.find(dir).to_a.reject do |file|
          # Don't match directories or
          # Files which begin or end with non-alpha characters
          # like: .hidden_file or emacs.backup~
          File.directory?(file) || !File.basename(file).match(/^\w.+?\w$/)
        end
      end

      def css
        @css.reject(&:disabled?).compact
      end

      def sass
        @sass.reject(&:disabled?).compact
      end

      # Internal: Remove Sass partials from Sass assets.
      # Partials can be in "stylesheets" or its sub-directories.
      #
      # Examples
      #
      #   _partial.scss is rejected
      #   dir/_partial.scss is rejected
      #   dir/dir/_partial.scss is rejected
      #   snake_case.scss is not rejected
      #   dir/snake_case.scss is not rejected
      #   dir/dir/snake_case.scss is not rejected
      #
      # Returns Sass assets not including partials.
      def sass_without_partials
        sass.reject { |f| File.basename(f.file).start_with?('_') }
      end

      def js
        @js.reject(&:disabled?).compact
      end

      def coffee
        @coffee.reject(&:disabled?).compact
      end

      def configuration; {}; end

      def set_config(name, value)
        instance_variable_set("@#{name}", value)
        instance_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def #{name}
            @#{name}
          end
        EOS
      end

      def add_assets; end

    end
  end
end
