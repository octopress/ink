module Octopress
  module Ink
    module Assets
      class Config < Asset

        def initialize(plugin, path)
          @root = plugin.assets_path
          @plugin = plugin
          @dir = plugin.slug
          @base = ''
          @exists = {}
          @file = path
        end

        def info
          config = plugin_path
          if exists? config
            " configuration defaults:\n" +
            File.open(plugin_path).read.gsub(/^/,'    ')
          else
            " No configuration."
          end
        end

        def read
          config = {}
          default = plugin_path
          if exists? default
            config = SafeYAML.load(File.open(default)) || {}
          end

          if exists? user_path
            user_config = SafeYAML.load(File.open(user_path)) || {}
            config = config.deep_merge(user_config)
          end

          config['permalinks'] ||= {}

          config
        end
      end
    end
  end
end

