module Octopress
  module Ink
    module Plugins
      attr_reader :registered, :css_asset_paths, :js_asset_paths
      extend self

      @registered = false
      @plugins = []
      @user_plugins = []

      def theme
        @theme
      end

      def each(&block)
        plugins.each(&block)
      end

      # Store static files to be written
      #
      def static_files
        @static_files
      end

      def size
        plugins.size
      end

      def plugin(slug)
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

      def plugins
        [@theme].concat(@plugins).concat(@user_plugins).compact
      end

      def reset
        @registered = false
      end

      def register
        unless @registered
          @registered = true
          @static_files = []
          @css_tags = []
          @js_tags = []
          Cache.reset
          Bootstrap.reset
          PluginAssetPipeline.reset

          plugins.each(&:register) 
        end
      end

      def add_files
        add_assets(%w{images pages files fonts docs})
        add_stylesheets
        add_javascripts
      end

      def add_assets(assets)
        plugins.each do |p| 
          p.add_asset_files(assets)
        end
      end

      def add_css_tag(tag)
        @css_tags << tag
      end

      def add_js_tag(tag)
        @js_tags << tag
      end

      def register_plugin(plugin, options=nil)
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

      def config(lang=nil)
        @configs ||= {}
        @configs[lang || 'default'] ||= get_config(lang)
      end

      def get_config(lang=nil)
        config            = {}
        config['plugins'] = {}

        plugins.each do |p|
          if p == theme
            config['theme'] = p.config(lang)
          else
            config['plugins'][p.slug] = p.config(lang)
          end
        end

        config
      end

      # Inclue partials from plugins
      #
      def include(name, file)
        p = plugin(name)
        p.include(file)
      end

      # Read plugin dir from site configs
      #
      def custom_dir
        Octopress.site.plugin_manager.plugins_path.first
      end

      # Copy/Generate Stylesheets
      #
      def add_stylesheets
        if Ink.configuration['asset_pipeline']['combine_css']
          PluginAssetPipeline.write_combined_stylesheet
        else
          add_assets(%w{css sass})
        end
      end
      
      # Copy/Generate Javascripts
      #
      def add_javascripts
        if Ink.configuration['asset_pipeline']['combine_js']
          PluginAssetPipeline.write_combined_javascript
        else
          add_assets(%w{js coffee})
        end
      end

      def css_tags
        if Ink.configuration['asset_pipeline']['combine_css']
          PluginAssetPipeline.stylesheet_tag
        else
          @css_tags.join('')
        end
      end

      def js_tags
        if Ink.configuration['asset_pipeline']['combine_js']
          PluginAssetPipeline.javascript_tag
        else
          @js_tags.join('')
        end
      end
    end
  end
end
