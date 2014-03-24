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
          plugin.disabled?('css', filename) ||
          plugin.disabled?('stylesheets', filename)
        end

        def destination
          File.join(base, plugin.slug, file.sub(/@(.+?)\./,'.'))
        end

        def tag
          "<link href='#{Filters.expand_url(File.join(dir, file))}' media='#{media}' rel='stylesheet' type='text/css'>"
        end
      end
    end
  end
end

