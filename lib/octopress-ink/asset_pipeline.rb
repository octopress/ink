module Octopress
  module Ink
    module AssetPipeline

      def self.compile_sass_file(path, options=nil)
        options ||= sass_options
        ::Sass.compile_file(path, options)
      end

      def self.compile_sass(contents, options)
        ::Sass.compile(contents, options)
      end

      def self.sass_options
        config = Plugins.site.config['sass']
        
        defaults = {
          'style'        => :compressed,
          'trace'        => false,
          'line_numbers' => false
        }

        options = defaults.deep_merge(config || {}).to_symbol_keys
        options = options.each{ |k,v| options[k] = v.to_sym if v.is_a? String }
        options
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
          contents = compile_sass(css[media], sass_options)
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
