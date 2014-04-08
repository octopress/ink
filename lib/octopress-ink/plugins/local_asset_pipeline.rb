# The CSS assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  module Ink
    class AssetPipelinePlugin < Plugin
      def configuration
        {
          name:        "Octopress Asset Pipeline",
          description: "Add your CSS and JS to the asset pipeline.",
          local:       true
        }
      end

      def config
        @config ||= Ink.config
      end

      def register_assets

        local_stylesheets.each {|f| add_stylesheet(f) }
        local_javascripts.each {|f| add_javascript(f) }

        remove_jekyll_assets @sass if @sass

        if config['concat_js']
          remove_jekyll_assets @javascripts if @javascripts
        end

        if config['concat_css']
          remove_jekyll_assets @css if @css
        end
      end

      def disabled?(dir, file)
        case dir
        when stylesheets_dir
          config['disable'].include?('site_stylesheets')
        when javascripts_dir
          config['disable'].include?('site_javascripts')
        end
      end

      def add_javascript(file)
        @javascripts << Assets::LocalJavascript.new(self, javascripts_dir, file)
      end

      def add_stylesheet(file)
        # accept ['file', 'media_type']
        #
        if file.is_a? Array
          if file.first =~ /\.css/
            @css << Assets::LocalStylesheet.new(self, stylesheets_dir, file.first, file.last)
          else
            @sass << Assets::LocalSass.new(self, stylesheets_dir, file.first, file.last)
          end
          
        # accept 'file'
        #
        else
          if file =~ /\.css/
            @css << Assets::LocalStylesheet.new(self, stylesheets_dir, file)
          else
            @sass << Assets::LocalSass.new(self, stylesheets_dir, file)
          end
        end
      end

      def javascripts_dir
        config['javascripts_dir']
      end

      def stylesheets_dir
        config['stylesheets_dir']
      end

      def local_stylesheets
        local_files('stylesheets', stylesheets_dir).reject do |f|
          File.basename(f) =~ /^_.*?s[ac]ss/
        end
      end

      def local_javascripts
        local_files('javascripts', javascripts_dir)
      end

      def local_files(type, dir)
        source = Plugins.site.source
        
        # If they manually specify files
        #
        if config[type].is_a?(Array) && !config[type].empty?
          config[type]
        else
          dir = File.join(source, dir)
          files = glob_assets(dir)
          files.map { |f| f.split(dir).last }
        end
      end
    end
  end
end

