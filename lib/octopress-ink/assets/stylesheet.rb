module Octopress
  module Ink
    module Assets
      class Stylesheet < Asset

        def initialize(plugin, base, file)
          @plugin = plugin
          @file = file
          @base = base
          @media = media || 'all'
          @root = plugin.assets_path
          @dir = File.join(plugin.slug, 'stylesheets')
          @exists = {}
          file_check
        end

        def media
          m = @media
          if file =~ /@(.+?)\./
            m = $1
          end
          m
        end

        def disabled?
          is_disabled('css', filename) || is_disabled('stylesheets', filename)
        end

        def tag
          "<link href='#{Filters.expand_url(File.join(dir, file))}' media='#{media}' rel='stylesheet' type='text/css'>"
        end

        private

        def destination
          File.join(base, plugin.slug, file.sub(/@(.+?)\./,'.'))
        end
      end
    end
  end
end

