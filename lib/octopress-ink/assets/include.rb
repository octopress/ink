module Octopress
  module Assets
    class Include < Asset

      def initialize(plugin, type)
        @plugin_type = plugin.type
        @root = plugin.assets_path
        @type = type
        @dir = File.join(plugin.namespace, type)
        @exists = {}
      end

      def file(file, site)
        @file = file
        path(site)
      end
    end
  end
end

