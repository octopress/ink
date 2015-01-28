module Octopress
  module Ink
    module Plugins

      @static_files = []
      @plugins = []
      @user_plugins = []
      @css_tags = []
      @js_tags = []

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

      def self.add_css_tag(tag)
        @css_tags << tag
      end

      def self.add_js_tag(tag)
        @js_tags << tag
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

      # Inclue partials from plugins
      #
      def self.include(name, file)
        p = plugin(name)
        p.include(file)
      end

      # Read plugin dir from site configs
      #
      def self.custom_dir
        Octopress.site.plugin_manager.plugins_path.first
      end

      # Copy/Generate Stylesheets
      #
      def self.add_stylesheets
        if Ink.configuration['asset_pipeline']['combine_css']
          PluginAssetPipeline.write_combined_stylesheet
        else
          add_assets(%w{css sass})
        end
      end
      
      # Copy/Generate Javascripts
      #
      def self.add_javascripts
        if Ink.configuration['asset_pipeline']['combine_js']
          PluginAssetPipeline.write_combined_javascript
        else
          add_assets(%w{js coffee})
        end
      end

      def self.css_tags
        if Ink.configuration['asset_pipeline']['combine_css']
          PluginAssetPipeline.combined_stylesheet_tag
        else
          @css_tags.join('')
        end
      end

      def self.js_tags
        if Ink.configuration['asset_pipeline']['combine_js']
          PluginAssetPipeline.combined_javascript_tag
        else
          @js_tags.join('')
        end
      end
    end
  end
end
