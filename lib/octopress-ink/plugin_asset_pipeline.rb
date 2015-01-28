module Octopress
  module Ink
    module PluginAssetPipeline

      # Compile CSS to take advantage of Sass's compression settings
      #
      def self.compile_css(content)
        configs = sass_converter.sass_configs
        configs[:syntax] = :scss
        configs[:style] ||= :compressed if Ink.configuration['asset_pipeline']['compress_css']

        Sass.compile(content, configs)
      end

      def self.compile_sass(sass)
        Sass.compile(sass.render, sass_configs(sass))
      end

      # Gets default Sass configuration hash from Jekyll
      #
      def self.sass_configs(sass)
        configs = sass_converter.sass_configs

        configs[:syntax] = sass.ext.sub(/^\./,'').to_sym

        if sass.respond_to? :load_paths
          configs[:load_paths] = sass.load_paths
        end

        configs
      end
      
      # Access Jekyll's built in Sass converter
      #
      def self.sass_converter
        if @sass_converter
          @sass_converter
        else
          Octopress.site.converters.each do |c|
            @sass_converter = c if c.kind_of?(Jekyll::Converters::Sass) 
          end
          @sass_converter
        end
      end

      # Return a link tag, for all plugins' stylesheets
      #
      def self.combined_stylesheet_tag
        tags = ''
        combine_stylesheets.keys.each do |media|
          tags.concat "<link href='#{Filters.expand_url(combined_stylesheet_path(media))}' media='#{media}' rel='stylesheet' type='text/css'>"
        end
        tags
      end

      def self.combined_javascript_tag
        unless @combined_js == ''
          "<script src='#{Filters.expand_url(combined_javascript_path)}'></script>"
        end
      end


      # Combine stylesheets from each plugin
      #
      # Returns a hash of stylesheets grouped by media types
      #
      #   output: { 'screen' => 'body { background... }' }
      #
      def self.combine_stylesheets
        if @combined_stylesheets
          @combined_stylesheets
        else
          combined = {}

          stylesheets.clone.each do |media,files|
            files.each do |file|
              header = "/* #{file.plugin.type.capitalize}: #{file.plugin.name} */"
              combined[media] ||= ''
              combined[media] << "#{header}\n" unless combined[media] =~ /#{file.plugin.name}/
              combined[media] << file.content
            end
          end

          @combined_stylesheets = combined
        end
      end

      def self.write_combined_stylesheet
        @combined_stylesheets = nil
        css = combine_stylesheets
        css.keys.each do |media|
          contents = compile_css(css[media])
          write_files(contents, combined_stylesheet_path(media)) 
        end
      end

      def self.combined_stylesheet_path(media)
        File.join('stylesheets', "#{media}-#{stylesheet_fingerprint(media)}.css")
      end

      def self.stylesheet_fingerprint(media)
        @stylesheet_fingerprint ||= {}
        @stylesheet_fingerprint[media] ||=
          fingerprint(stylesheets[media].clone.map(&:path))
      end

      # Get all plugins stylesheets
      #
      # Returns a hash of assets grouped by media
      #
      #   output: { 'screen' => [Octopress::Ink::Assets::Stylesheet, ..]
      #
      def self.stylesheets
        if @stylesheets
          @stylesheets
        else
          files = {}
          Plugins.plugins.clone.each do |plugin| 
            plugin.stylesheets.each do |file|
              files[file.media] ||= []
              files[file.media] << file
            end
          end
          @stylesheets = files
        end
      end

      def self.javascripts
        @javascripts ||=
          Plugins.plugins.clone.map(&:javascripts).flatten
      end

      def self.javascript_fingerprint
        @javascript_fingerprint ||=
          fingerprint(javascripts.clone.map(&:path))
      end

      def self.combined_javascript_path
        File.join('javascripts', "all-#{javascript_fingerprint}.js")
      end

      def self.write_combined_javascript
        @combined_js = ''

        if Ink.configuration['asset_pipeline']['combine_js']
          javascripts.each do |file|

            js = if compress_js?(file)
              @uglify_settings ||= Jekyll::Utils.symbolize_hash_keys(Ink.configuration['asset_pipeline']['uglifier'])

              if cached = Cache.read_cache(file, @uglify_settings)
                cached
              else
                js = Uglifier.new(@uglify_settings).compile(file.content)
                Cache.write_to_cache(file, js, @uglify_settings)
              end
            else
              file.content
            end

            unless @combined_js =~ /#{file.plugin.name}/
              @combined_js << "/* #{file.plugin.type.capitalize}: #{file.plugin.name} */\n" 
            end
            @combined_js << js
          end

          unless @combined_js == ''
            write_files(@combined_js, combined_javascript_path)
          end
        end
      end

      def self.compress_js?(file)
        Ink.configuration['asset_pipeline']['compress_js'] && !file.path.end_with?('.min.js')
      end

      def self.write_files(source, dest)
        Plugins.static_files << StaticFileContent.new(source, dest)
      end

      def self.fingerprint(paths)
        return '' if ENV['JEKYLL_ENV'] == 'test'
        paths = [paths] unless paths.is_a? Array
        Digest::MD5.hexdigest(paths.clone.map! { |path| "#{File.mtime(path).to_i}" }.join)
      end
      
    end
  end
end
