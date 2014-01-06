module Octopress
  module Assets
    class Stylesheet < Asset
      def initialize(plugin, type, file, media)
        @file = file
        @type = type
        @root = plugin.assets_path
        @dir = File.join(plugin.namespace, type)
        @plugin_type = plugin.type
        @media = media || 'all'
        @exists = {}
      end

      def media
        @media
      end

      def tag
        "<link href='/#{File.join(@dir, @file)}' media='#{@media}' rel='stylesheet' type='text/css'>"
      end
    end
  end
end

