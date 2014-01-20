# These are files which need to be in added to the root of the site directory
# Use root assets for files like robots.text or favicon.ico


module Octopress
  module Assets
    class RootAsset < Asset

      def initialize(plugin, type, file)
        @root = plugin.assets_path
        @plugin = plugin
        @dir = ''
        @type = type
        @exists = {}
        @file = file
        file_check
      end

      def copy(site)
        unless exists? local_plugin_path(site)
          site.static_files << StaticFile.new(plugin_path, destination)
        end
      end

    end
  end
end

