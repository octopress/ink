module Octopress
  module Ink
    module PluginAssetPipeline

      # Compile CSS to take advantage of Sass's compression settings
      #
      def self.compile_css(content)
        configs = sass_converter.sass_configs
        configs[:syntax] = :scss

        Sass.compile(content, configs)
      end

      def self.compile_sass(sass)
        Sass.compile(sass.content, sass_configs(sass))
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
          Ink.site.converters.each do |c|
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
        unless combine_javascripts == ''
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
              combined[media] << file.read
            end
          end

          @combined_stylesheets = combined
        end
      end

      def self.write_combined_stylesheet
        css = combine_stylesheets
        css.keys.each do |media|
          contents = compile_css(css[media])
          contents = AutoprefixerRails.process(contents)
          write_files(contents, combined_stylesheet_path(media)) 
        end
      end

      def self.combined_stylesheet_path(media)
        File.join('stylesheets', "#{media}-#{stylesheet_fingerprint(media)}.css")
      end

      def self.stylesheet_fingerprint(media)
        @stylesheet_fingerprint ||= {}
        @stylesheet_fingerprint[media] ||=
          fingerprint(stylesheets[media].clone.map {|f| f.path })
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
          Plugins.plugins.clone.map { |p| p.javascripts }.flatten
      end

      def self.javascript_fingerprint
        @javascript_fingerprint ||=
          fingerprint(javascripts.clone.map {|f| f.path })
      end

      def self.combine_javascripts
        if @combined_javascript
          @combined_javascript
        else
          js = ""
          javascripts.clone.each do |f| 
            unless js =~ /#{f.plugin.name}/
              js += "/* #{f.plugin.type.capitalize}: #{f.plugin.name} */\n" 
            end
            js += f.read
          end
          @combined_javascript = js
        end
      end

      def self.combined_javascript_path
        File.join('javascripts', "all-#{javascript_fingerprint}.js")
      end

      def self.write_combined_javascript
        js = combine_javascripts
        write_files(js, combined_javascript_path) unless js == ''
      end

      def self.write_files(source, dest)
        Plugins.static_files << StaticFileContent.new(source, dest)
      end

      def self.fingerprint(paths)
        paths = [paths] unless paths.is_a? Array
        Digest::MD5.hexdigest(paths.clone.map! { |path| "#{File.mtime(path).to_i}" }.join)
      end
      
    end
  end
end
