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
            config = YAML.safe_load(File.open(default)) || {}
          end

          if exists? user_path
            user_config = YAML.safe_load(File.open(user_path)) || {}
            config = config.deep_merge(user_config)
          end

          config
        end
      end
    end
  end
end

