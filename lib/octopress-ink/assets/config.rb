module Octopress
  module Assets
    class Config < Asset

      def initialize(plugin, path)
        @root = plugin.assets_path
        @plugin = plugin
        @dir = plugin.namespace
        @type = ''
        @exists = {}
        @file = path
      end

      def user_dir(site)
        File.join site['source'], Plugins.custom_dir(site), @dir
      end

      def local_plugin_path(site)
        File.join site['source'], @dir, @file
      end

      def read(site)
        config = {}
        if @plugin.type != 'local_plugin'
          default = plugin_path
          if exists? default
            config = YAML::load(File.open(default))
          end
        end
        override = user_path(site)
        if exists? override
          config = config.deep_merge YAML::load(File.open(override))
        end
        config
      end
    end
  end
end

