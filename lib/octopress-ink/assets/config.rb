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

        # If config plugin config file exists, return contents for list command
        def info
          if exists?(config = plugin_path)
            Ink::Utils.pretty_print_yaml(read)
          else
            "   none"
          end
        end

        def read
          config = {}
          default = plugin_path
          if exists? default
            config = SafeYAML.load_file(default) || {}
          end

          if exists? user_path
            user_config = SafeYAML.load_file(user_path) || {}
            config = Jekyll::Utils.deep_merge_hashes(config, user_config)
          end

          config['permalinks'] ||= {}

          config
        end
      end
    end
  end
end

