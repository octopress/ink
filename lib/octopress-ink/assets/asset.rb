module Octopress
  module Ink
    module Assets
      class Asset
        attr_reader :plugin, :dir, :base, :root, :file
        attr_accessor :exists

        def initialize(plugin, base, file)
          @file = file
          @base = base
          @plugin = plugin
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, base)
          @exists = {}
          file_check
        end

        def info
          message = filename.ljust(35)
          if disabled?
            message += "disabled"
          elsif self.respond_to?(:url_info)
            message += url_info
          elsif path.to_s != plugin_path
            shortpath = File.join(Plugins.custom_dir, dir)
            message += "from: #{shortpath}/#{filename}"
          end
          message
        end

        def filename
          file
        end

        def disabled?
          plugin.disabled?(base, filename)
        end

        def path
          if @found_file
            @found_file
          else
            files = []
            files << user_path
            files << plugin_path
            files = files.flatten.reject { |f| !exists? f }

            if files.empty?
              raise IOError.new "Could not find #{File.basename(file)} at #{file}"
            end
            @found_file = Pathname.new files[0]
          end
        end

        def read
          path.read
        end

        def source_dir
          if exists? user_override_path
            user_dir
          else
            plugin_dir
          end
        end

        def destination
          File.join(dir, file)
        end

        def add
          Plugins.static_files << StaticFile.new(path, destination)
        end

        # Copy asset to user override directory
        #
        def copy(target_dir)
          if target_dir
            target_dir = File.join(target_dir, base)
          else
            target_dir = user_dir
          end
          FileUtils.mkdir_p target_dir
          FileUtils.cp plugin_path, target_dir
          target_dir.sub!(Dir.pwd+'/', '')
          "+ ".green + "#{File.join(target_dir, filename)}"
        end


        def plugin_dir
          File.join root, base
        end

        def plugin_path
          File.join plugin_dir, file
        end

        def user_dir
          File.join Plugins.site.source, Plugins.custom_dir, dir
        end

        def local_plugin_path
          File.join Plugins.site.source, dir, file
        end

        def user_override_path
          File.join user_dir, filename
        end

        def user_path
          user_override_path
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
          if !exists? plugin_path
            raise "\nPlugin: #{plugin.name}: Could not find #{File.basename(file)} at #{plugin_path}".red
          end
        end

        def exists?(file)
          exists[file] ||= File.exists?(file)
          exists[file]
        end
      end
    end
  end
end
