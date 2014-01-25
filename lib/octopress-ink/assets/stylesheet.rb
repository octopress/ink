module Octopress
  module Assets
    class Stylesheet < Asset
      def initialize(plugin, type, file, media)
        @plugin = plugin
        @file = file
        @type = type
        @media = media || 'all'
        @root = plugin.assets_path
        @dir = File.join(plugin.namespace, type)
        @exists = {}
        file_check
      end

      def media
        m = @media
        if @file =~ /@(.+?)\./
          m = $1
        end
        m
      end

      def destination
        File.join(@dir, @file.sub(/@(.+?)\./,'.'))
      end

      def tag
        "<link href='#{Filters.expand_url(File.join(@dir, @file))}' media='#{media}' rel='stylesheet' type='text/css'>"
      end
    end
  end
end

