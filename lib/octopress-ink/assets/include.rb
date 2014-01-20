module Octopress
  module Assets
    class Include < Asset

      def initialize(plugin, type)
        @root = plugin.assets_path
        @type = type
        @plugin = plugin
        @dir = File.join(plugin.namespace, type)
        @no_cache = true
        @exists = {}
      end
    end
  end
end

