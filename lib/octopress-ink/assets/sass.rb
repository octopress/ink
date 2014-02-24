module Octopress
  module Ink
    module Assets
      class Sass < Stylesheet
        def initialize(plugin, base, file, media)
          @plugin = plugin
          @base = base
          @file = file
          @media = media || 'all'
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, base)
          @exists = {}
          file_check
        end

        def tag
          "<link href='#{Filters.expand_url(File.join(@dir, @file))}' media='#{media}' rel='stylesheet' type='text/css'>"
        end

        # TODO: see if this is done TODO: choose user path before local path.
        def user_load_path
          File.join(Plugins.site.source, Plugins.custom_dir, @dir, File.dirname(@file)).sub /\/\.$/, ''
        end

        def theme_load_path
          File.expand_path(File.join(@root, @base))
        end

        def disabled?
          @plugin.disabled?('sass', filename)
        end

        def compile
          unless @compiled
            options = Plugins.sass_options
            if @plugin.type == 'local_plugin'
              @compiled = Plugins.compile_sass_file(path.to_s, options)
            else
              # If the plugin isn't a local plugin, add source paths to allow overrieds on @imports.
              #
              options[:load_paths] = [user_load_path, theme_load_path]
              @compiled = Plugins.compile_sass(path.read, options)
            end
          end
          @compiled
        end

        def user_override_path
          # Allow Sass overrides to use either syntax
          if @file =~ /s[ac]ss$/
            [File.join(user_dir, @file), File.join(user_dir, alt_syntax_file)]
          else
            File.join user_dir, @file
          end
        end

        def destination
          File.join(@dir, @file.sub(/s.ss/, 'css'))
        end

        def copy
          Plugins.site.static_files << StaticFileContent.new(compile, destination)
        end
      end
    end
  end
end

