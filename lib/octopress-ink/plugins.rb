module Octopress
  module Ink
    module Plugins

      @static_files = []
      @plugins = []
      @user_plugins = []

      def self.theme
        @theme
      end

      def self.each(&block)
        plugins.each(&block)
      end

      # Store static files to be written
      #
      def self.static_files
        @static_files
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

      def self.register
        plugins.each do |p| 
          p.register
        end
      end

      def self.add_files
        add_assets(%w{images pages files fonts docs})
        add_stylesheets
        add_javascripts
      end

      def self.add_assets(assets)
        plugins.each do |p| 
          p.add_asset_files(assets)
        end
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

      # Inclue partials from plugins
      #
      def self.include(name, file)
        p = plugin(name)
        p.include(file)
      end

      # Read plugin dir from site configs
      #
      def self.custom_dir
        Ink.site.config['plugins']
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
    end
  end
end
