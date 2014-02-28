module Octopress
  module Ink
    module Assets
      class LocalAsset < Asset
        def initialize(plugin, base, file)
          @plugin = plugin
          @file = file
          @base = base
          @dir = base.sub(/^_/,'')
          @root = Plugins.site.source
        end

        def info
          message = filename.ljust(35)
          message += "from: #{@base}"
        end

        def path
          Pathname.new File.join(@root, @base, @file)
        end

        def destination
          File.join(@dir, @file)
        end

        def add
          Plugins.site.static_files << StaticFile.new(path, destination)
        end

        # Copy asset to user override directory
        #
        def copy(target_dir)
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
      end
    end
  end
end
