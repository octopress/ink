module Octopress
  module Assets
    class Include < Asset

      def initialize(plugin, type)
        @root = plugin.assets_path
        @type = type
        @plugin = plugin
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

