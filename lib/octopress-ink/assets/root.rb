# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico

module Octopress
  module Ink
    module Assets
      class RootAsset < Asset

        def initialize(plugin, base, file)
          @root = plugin.assets_path
          @plugin = plugin
          @dir = ''
          @base = base
          @file = file
          @exists = {}
          file_check
        end

        def user_dir
          File.join Plugins.site.source, Plugins.custom_dir, @plugin.slug, 'files', @dir
        end

        def add
          unless exists? local_plugin_path
            Plugins.site.static_files << StaticFile.new(File.join(source_dir, @file), destination)
          end
        end

      end
    end
  end
end

