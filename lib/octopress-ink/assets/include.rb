module Octopress
  module Ink
    module Assets
      class Include < Asset

        def initialize(plugin, type)
          @root = plugin.assets_path
          @type = type
          @plugin = plugin
          @dir = File.join(plugin.slug, type)
          @no_cache = true
          @exists = {}
        end
      end
    end
  end
end

