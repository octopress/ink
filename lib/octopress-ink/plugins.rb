module Octopress
  module Ink
    module Plugins
      @plugins = []
      @user_plugins = []
      @site = nil

      def self.theme
        @theme
      end

      def self.each(&block)
        plugins.each(&block)
      end

      def self.size
        plugins.size
      end

      def self.plugin(slug)
        if slug == 'theme'
          @theme
        else
          found = plugins.reject { |p| p.slug != slug }
          if found.empty?
            raise IOError.new "No Theme or Plugin with the slug '#{slug}' was found."
          end
          found.first
        end
      end

      def self.plugins
        [@theme].concat(@plugins).concat(@user_plugins).compact
      end

      def self.register(site)
        unless @site
          @site = site
          plugins.each do |p| 
            p.register
          end
        end
      end

      def self.add_files
        add_assets(%w{images pages files fonts docs})
        plugin('octopress-asset-pipeline').register_assets
        add_stylesheets
        add_javascripts
      end

      def self.add_assets(assets)
        plugins.each do |p| 
          p.add_asset_files(assets)
        end
      end

      def self.site
        @site
      end

      def self.register_plugin(plugin, options=nil)
        new_plugin = plugin.new(options)

        case new_plugin.type
        when 'theme'
          @theme = new_plugin
        else
          if new_plugin.local
            @user_plugins << new_plugin
          else
            @plugins << new_plugin
          end
        end
      end

      def self.config
        if @config
          @config
        else
          @config            = {}
          @config['plugins'] = {}
          @config['theme']   = @theme.nil? ? {} : @theme.config

          plugins.each do |p| 
            unless p == @theme
              @config['plugins'][p.slug] = p.config
            end
          end

          @config
        end
      end

      # Docs pages for each plugin
      #
      # returns: Array of plugin doc pages
      #
      def self.doc_pages
        plugin_docs = {}
        plugins.clone.map do |p|
          if pages = p.doc_pages
            plugin_docs[p.slug] = {
              "name" => p.name,
              "pages" => pages
            }
          end
        end
        plugin_docs
      end

      def self.include(name, file)
        p = plugin(name)
        p.include(file)
      end

      def self.custom_dir
        site.config['plugins']
      end

      # Copy/Generate Stylesheets
      #
      def self.add_stylesheets
        if Ink.config['concat_css']
          AssetPipeline.write_combined_stylesheet
        else
          add_assets(%w{css sass})
        end
      end
      
      # Copy/Generate Javascripts
      #
      def self.add_javascripts
        if Ink.config['concat_js']
          AssetPipeline.write_combined_javascript
        else
          add_assets(%w{javascripts})
        end
      end

      def self.stylesheet_tags
        if Ink.config['concat_css']
          AssetPipeline.combined_stylesheet_tag
        else
          plugins.clone.map { |p| p.stylesheet_tags }.join('')
        end
      end

      def self.javascript_tags
        if Ink.config['concat_js']
          AssetPipeline.combined_javascript_tag
        else
          js = []
          plugins.each do |plugin| 
            js.concat plugin.javascript_tags
          end
          js
        end
      end

      def self.fingerprint(paths)
        paths = [paths] unless paths.is_a? Array
        Digest::MD5.hexdigest(paths.clone.map! { |path| "#{File.mtime(path).to_i}" }.join)
      end

    end
  end
end
