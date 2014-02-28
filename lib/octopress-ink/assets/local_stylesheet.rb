module Octopress
  module Ink
    module Assets
      class LocalStylesheet < LocalAsset
        def initialize(plugin, base, file, media=nil)
          @plugin = plugin
          @file = file
          @base = base
          @root = Plugins.site.source
          @dir = base.sub(/^_/,'')
          @media = media || 'all'
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

