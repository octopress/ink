module Octopress
  module Assets
    class Sass < Asset
      def initialize(plugin, type, file, media)
        @file = file
        @type = type
        @plugin_type = plugin.type
        @root = plugin.assets_path
        @dir = File.join(plugin.namespace, type)
        @exists = {}
        @media = media || 'all'
      end

      def media
        @media
      end

      def tag
        "<link href='/#{File.join(@dir, @file)}' media='#{@media}' rel='stylesheet' type='text/css'>"
      end

      # TODO: choose user path before local path.
      def user_load_path(site)
        File.join(site.source, Plugins.custom_dir(site), @dir, File.dirname(@file)).sub /\/\.$/, ''
      end

      def theme_load_path
        File.expand_path(File.join(@root, @type))
      end

      # Remove sass files from Jekyll's static_files array so it doesn't end up in the
      # compiled site directory. 
      #
      def remove_static_file(site)
        site.static_files.clone.each do |sf|
          if sf.kind_of?(Jekyll::StaticFile) && sf.path == path(site).to_s
            site.static_files.delete(sf)
          end
        end
      end

      def compile(site)
        unless @compiled
          options = Plugins.sass_options(site)
          if @plugin_type == 'local_plugin'
            remove_static_file(site)
            @compiled = Plugins.compile_sass_file(path(site).to_s, options)
          else
            # If the plugin isn't a local plugin, add source paths to allow overrieds on @imports.
            #
            options[:load_paths] = [user_load_path(site), theme_load_path]
            @compiled = Plugins.compile_sass(path(site).read, options)
          end
        end
        @compiled
      end

      def user_override_path(site)
        # Allow Sass overrides to use either syntax
        if @file =~ /s[ac]ss$/
          [File.join(user_dir(site), @file), File.join(user_dir(site), alt_syntax_file)]
        else
          File.join user_dir(site), @file
        end
      end

      def destination
        File.join(@dir, @file.sub(/s.ss/, 'css'))
      end

      def copy(site)
        site.static_files << StaticFileContent.new(compile(site), destination)
      end
    end
  end
end

