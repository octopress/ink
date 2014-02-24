module Octopress
  module Ink
    module Assets
      class Stylesheet < Asset
        def initialize(plugin, base, file, media)
          @plugin = plugin
          @file = file
          @base = base
          @media = media || 'all'
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, 'stylesheets')
          @exists = {}
          file_check
        end

        def type
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
end

