# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico

module Octopress
  module Ink
    module Assets
      class FileAsset < Asset

        def initialize(plugin, base, file)
          @root = plugin.assets_path
          @plugin = plugin
          @base = base
          @filename = file
          @dir  = File.dirname(file)
          @file = File.basename(file)
          @exists = {}
          file_check
        end

        def filename
          @filename
        end

        def user_dir
          File.join Plugins.site.source, Plugins.custom_dir, plugin.slug, base
        end

        def add
          if !exists?(local_plugin_path) && !Octopress::Ink.config['docs_mode']
            Plugins.site.static_files << StaticFile.new(File.join(source_dir, file), destination)
          end
        end
      end
    end
  end
end

