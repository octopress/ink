module Octopress
  module Ink
    module Assets
      class Asset

        def initialize(plugin, type, file)
          @file = file
          @type = type
          @plugin = plugin
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, type)
          @exists = {}
          file_check
        end

        def file
          @file
        end

        def path
          if @found_file and !@no_cache
            @found_file
          else
            files = []
            files << user_path
            files << plugin_path unless @plugin.type == 'local_plugin'
            files = files.flatten.reject { |f| !exists? f }

            if files.empty?
              raise IOError.new "Could not find #{File.basename(@file)} at #{@file}"
            end
            @found_file = Pathname.new files[0]
          end
        end

        def file(file)
          @file = file
          path
        end

        def destination
          File.join(@dir, @file)
        end

        def copy
          Plugins.site.static_files << StaticFile.new(path, destination)
        end

        def plugin_dir
          File.join @root, @type
        end

        def plugin_path
          File.join plugin_dir, @file
        end

        def user_dir
          File.join Plugins.site.source, Plugins.custom_dir, @dir
        end

        def local_plugin_path
          File.join Plugins.site.source, @dir, @file
        end

        def user_override_path
          File.join user_dir, @file
        end

        def user_path
          if @plugin.type == 'local_plugin'
            local_plugin_path
          else
            user_override_path
          end
        end

        def alt_syntax_file
          ext = File.extname(@file)
          alt_ext = ext == 'scss' ? 'sass' : 'scss'
          @file.sub(/\.#{ext}/, ".#{alt_ext}")
        end
        
        # Remove files from Jekyll's static_files array so it doesn't end up in the
        # compiled site directory. 
        #
        def remove_jekyll_asset
          Plugins.site.static_files.clone.each do |sf|
            if sf.kind_of?(Jekyll::StaticFile) && sf.path == path.to_s
              Plugins.site.static_files.delete(sf)
            end
          end
        end

        def file_check
          if @plugin.type != 'local_plugin' and !exists? plugin_path
            raise "\nPlugin: #{@plugin.name}: Could not find #{File.basename(@file)} at #{plugin_path}".red
          end
        end

        def exists?(file)
          @exists[file] ||= File.exists?(file)
          @exists[file]
        end
      end
    end
  end
end
