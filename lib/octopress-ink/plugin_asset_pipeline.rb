module Octopress
  module Ink
    module PluginAssetPipeline
      extend self

      def reset
        @sass_converter = nil
        @combined_stylesheets = nil
        @stylesheets = nil
        @javascripts = nil
        @uglify_settings = nil
        @combined_js = ''
        @stylesheet_fingerprint = {}
        @javascript_fingerprint = nil
        @uglify_settings ||= Jekyll::Utils.symbolize_hash_keys(Ink.configuration['asset_pipeline']['uglifier'])
        @css_dir = Ink.configuration['asset_pipeline']['stylesheets_destination']
        @js_dir  = Ink.configuration['asset_pipeline']['javascripts_destination']
      end

      # Compile CSS to take advantage of Sass's compression settings
      #
      def compile_css(content)
        configs = sass_converter.sass_configs
        configs[:syntax] = :scss
        configs[:style] ||= :compressed if Ink.configuration['asset_pipeline']['compress_css']

        Sass.compile(content, configs)
      end

      def compile_sass(sass)
        Sass.compile(sass.render, sass_configs(sass))
      end

      # Gets default Sass configuration hash from Jekyll
      #
      def sass_configs(sass)
        configs = sass_converter.sass_configs

        configs[:syntax] = sass.ext.sub(/^\./,'').to_sym

        if sass.respond_to? :load_paths
          configs[:load_paths] = sass.load_paths
        end

        configs
      end
      
      # Access Jekyll's built in Sass converter
      #
      def sass_converter
        @sass_converter ||= begin
          Octopress.site.converters.find do |c|
            c.kind_of?(Jekyll::Converters::Sass) 
          end
        end
      end

      # Return a link tag, for all plugins' stylesheets
      #
      def stylesheet_tag
        if Ink.configuration['asset_pipeline']['async_css']
          async_stylesheet_tag
        else
          combined_stylesheet_tag
        end
      end

      def combined_stylesheet_tag
        tags = ''
        combined_stylesheet_urls.each do |media, url|
          tags.concat "<link href='#{url}' media='#{media}' rel='stylesheet' type='text/css'>"
        end
        tags
      end

      def async_stylesheet_tag
        js = uglify(File.read(Ink.gem_dir('assets','js','loadCSS.js')))
        %Q{<script>#{js}\n#{load_css}\n</script>\n<noscript>#{combined_stylesheet_tag}</noscript>}
      end

      def load_css
        script = ''
        combined_stylesheet_urls.each do |media, url|
          script << %Q{loadCSS("#{url}", null, "#{media}")\n}
        end
        script
      end

      def combined_stylesheet_urls
        urls = {}
        combine_stylesheets.keys.each do |media|
          urls[media] = combined_stylesheet_url(media)
        end
        urls
      end

      def combined_stylesheet_url(media)
        Filters.expand_url(combined_stylesheet_path(media))
      end

      def javascript_tag
        unless @combined_js == ''
          if Ink.configuration['asset_pipeline']['async_js']
            "<script async src='#{combined_javascript_url}'></script>"
          else
            "<script src='#{combined_javascript_url}'></script>"
          end
        end
      end

      def combined_javascript_url
        Filters.expand_url(combined_javascript_path)
      end

      # Combine stylesheets from each plugin
      #
      # Returns a hash of stylesheets grouped by media types
      #
      #   output: { 'screen' => 'body { background... }' }
      #
      def combine_stylesheets
        @combined_stylesheets ||= begin
          combined = {}


          stylesheets.clone.each do |media,files|
            files.each do |file|
              header = "/* #{file.plugin.type.capitalize}: #{file.plugin.name} */"
              combined[media] ||= ''
              combined[media] << "#{header}\n" unless combined[media] =~ /#{file.plugin.name}/
              combined[media] << file.content
            end
          end

          combined
        end
      end

      def write_combined_stylesheet
        css = combine_stylesheets
        css.keys.each do |media|
          contents = compile_css(css[media])
          write_files(contents, combined_stylesheet_path(media)) 
        end
      end

      def combined_stylesheet_path(media)
        File.join(@css_dir, "#{media}-#{stylesheet_fingerprint(media)}.css")
      end

      def stylesheet_fingerprint(media)
        @stylesheet_fingerprint[media] ||=
          fingerprint(stylesheets[media].clone.map(&:path))
      end

      # Get all plugins stylesheets
      #
      # Returns a hash of assets grouped by media
      #
      #   output: { 'screen' => [Octopress::Ink::Assets::Stylesheet, ..]
      #
      def stylesheets
       @stylesheets ||= begin
          files = {}
          Plugins.plugins.clone.each do |plugin| 
            plugin.stylesheets.each do |file|
              files[file.media] ||= []
              files[file.media] << file
            end
          end
          files
        end
      end

      def javascripts
        @javascripts ||=
          Plugins.plugins.clone.map(&:javascripts).flatten
      end

      def javascript_fingerprint
        @javascript_fingerprint ||=
          fingerprint(javascripts.clone.map(&:path))
      end

      def combined_javascript_path
        File.join(@js_dir, "all-#{javascript_fingerprint}.js")
      end

      def write_combined_javascript
        if Ink.configuration['asset_pipeline']['combine_js']
          javascripts.each do |file|

            js = if compress_js?(file)
              if cached = Cache.read_cache(file, @uglify_settings)
                cached
              else
                js = uglify(file.content)
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

      def uglify(js)
        Uglifier.new(@uglify_settings).compile(js)
      end

      def compress_js?(file)
        Ink.configuration['asset_pipeline']['compress_js'] && !file.path.end_with?('.min.js')
      end

      def write_files(source, dest)
        Plugins.static_files << StaticFileContent.new(source, dest)
      end

      def fingerprint(paths)
        return '' if ENV['JEKYLL_ENV'] == 'test'
        paths = [paths] unless paths.is_a? Array
        Digest::MD5.hexdigest(paths.clone.map! { |path| "#{File.mtime(path).to_i}" }.join)
      end
      
    end
  end
end
