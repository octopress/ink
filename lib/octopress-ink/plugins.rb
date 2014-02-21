module Octopress
  module Ink
    module Plugins

      @plugins = []
      @local_plugins = []
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

      def self.plugin(name)
        if name == 'theme'
          @theme
        else
          found = plugins.reject { |p| p.name != name }
          if found.empty?
            raise IOError.new "No Theme or Plugin with the name '#{name}' was found."
          end
          found.first
        end
      end

      def self.plugins
        [@theme].concat(@plugins).concat(@local_plugins).compact
      end

      def self.site=(site)
        @site = site
      end

      def self.site
        @site
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
              @config['plugins'][p.name] = p.config
            end
          end

          @config
        end
      end

      def self.include(name, file)
        p = plugin(name)
        p.include(file)
      end

      def self.register_plugin(plugin, name, type='plugin')
        new_plugin = plugin.new(name, type)

        case type
        when 'theme'
          @theme = new_plugin
        when 'local_plugin'
          @local_plugins << new_plugin
        else
          @plugins << new_plugin
        end
      end

      def self.register_layouts
        plugins.each do |p|
          p.layouts.clone.each { |layout| layout.register }
        end
      end

      def self.layouts
        names = []
        plugins.each do |p|
          p.layouts.each { |layout| names << layout.name }
        end
        names
      end

      def self.custom_dir
        @site.config['plugins']
      end

      def self.fingerprint(paths)
        paths = [paths] unless paths.is_a? Array
        Digest::MD5.hexdigest(paths.clone.map! { |path| "#{File.mtime(path).to_i}" }.join)
      end
      
      def self.combined_stylesheet_path(media)
        File.join('stylesheets', "#{media}-#{@combined_stylesheets[media][:fingerprint]}.css")
      end

      def self.combined_javascript_path
        print = @javascript_fingerprint || ''
        File.join('javascripts', "#{print}.js")
      end

      def self.write_files(source, dest)
        @site.static_files << StaticFileContent.new(source, dest)
      end

      def self.compile_sass_file(path, options)
        ::Sass.compile_file(path, options)
      end

      def self.compile_sass(contents, options)
        ::Sass.compile(contents, options)
      end

      def self.sass_config(item, default)
        config = @site.config
        if config['octopress'] && config['octopress']['sass'] && config['octopress']['sass'][item]
          config['octopress']['sass'][item]
        else
          default
        end
      end
      
      def self.sass_options
        options = {
          style:        sass_config('output_style', 'compressed').to_sym,
          trace:        sass_config('trace', false),
          line_numbers: sass_config('line_numbers', false)
        }
      end

      def self.write_combined_stylesheet
        css = combine_stylesheets
        css.keys.each do |media|
          options = sass_options
          options[:line_numbers] = false
          contents = compile_sass(css[media][:contents], options)
          write_files(contents, combined_stylesheet_path(media)) 
        end
      end

      def self.write_combined_javascript
        js = combine_javascripts
        write_files(js, combined_javascript_path) unless js == ''
      end

      def self.combine_stylesheets
        unless @combined_stylesheets
          css = {}
          paths = {}
          plugins.each do |plugin|
            if plugin.type == 'theme'
              plugin_header = "/* Theme: #{plugin.name} */\n"
            else
              plugin_header = "/* Plugin: #{plugin.name} */\n"
            end
            stylesheets = plugin.stylesheets.clone.concat plugin.sass
            stylesheets.each do |file|
              css[file.media] ||= {}
              css[file.media][:contents] ||= ''
              css[file.media][:contents] << plugin_header
              css[file.media][:paths] ||= []
              
              # Add Sass files
              if file.respond_to? :compile
                css[file.media][:contents].concat file.compile
              else
                css[file.media][:contents].concat file.path.read.strip
              end
              css[file.media][:paths] << file.path
              plugin_header = ''
            end
          end

          css.keys.each do |media|
            css[media][:fingerprint] = fingerprint(css[media][:paths])
          end
          @combined_stylesheets = css
        end
        @combined_stylesheets
      end

      def self.combine_javascripts
        unless @combined_javascripts
          js = ''
          plugins.each do |plugin| 
            paths = plugin.javascript_paths
            @javascript_fingerprint = fingerprint(paths)
            paths.each do |file|
              js.concat Pathname.new(file).read
            end
          end
          @combined_javascripts = js
        end
        @combined_javascripts
      end

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

      def self.stylesheet_tags
        if concat_css
          combined_stylesheet_tag
        else
          css = []
          plugins.each do |plugin| 
            css.concat plugin.stylesheet_tags
            css.concat plugin.sass_tags
          end
          css
        end
      end

      def self.concat_css
        config = @site.config
        if config['octopress'] && !config['octopress']['concat_css'].nil?
          config['octopress']['concat_css'] != false
        else
          true
        end
      end

      def self.concat_js
        config = @site.config
        if config['octopress'] && !config['octopress']['concat_js'].nil?
          config['octopress']['concat_js'] != false
        else
          true
        end
      end

      def self.javascript_tags
        if concat_js
          combined_javascript_tag
        else
          js = []
          plugins.each do |plugin| 
            js.concat plugin.javascript_tags
          end
          js
        end
      end

      def self.copy_javascripts
        plugins.each do |plugin| 
          copy plugin.javascripts
        end
      end

      def self.copy_stylesheets
        stylesheets = plugins.clone.map { 
          |p| p.stylesheets.clone.concat(p.sass) 
        }.flatten
        copy stylesheets
      end

      def self.add_static_files
       
        plugin('user stylesheets').add_files
   
        # Copy/Generate Stylesheets
        #
        if concat_css
          write_combined_stylesheet
        else
          copy_stylesheets
        end

        # Copy/Generate Javascripts
        #
        if concat_js
          write_combined_javascript
        else
          copy_javascripts
        end

        # Copy other assets
        #
        copy_static_files
      end

      def self.copy_static_files
        plugins.each do |plugin| 
          copy plugin.files
          copy plugin.pages
          copy plugin.images
          copy plugin.fonts
        end
      end

      def self.copy(files)
        files.each { |f| f.copy }
      end
    end
  end
end

