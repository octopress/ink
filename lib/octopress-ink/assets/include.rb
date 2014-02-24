module Octopress
  module Ink
    module Assets
      class Include < Asset

        def initialize(plugin, base)
          @root = plugin.assets_path
          @base = base
          @plugin = plugin
          @dir = File.join(plugin.slug, base)
          @no_cache = true
          @exists = {}
        end
      end
    end
  end
end

