module Octopress
  module Assets
    class Stylesheet < Asset
      def initialize(plugin, type, file, media)
        @file = file
        @type = type
        @plugin = plugin
        @root = plugin.assets_path
        @dir = File.join(plugin.namespace, type)
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

