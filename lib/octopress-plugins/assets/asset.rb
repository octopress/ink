module Octopress
  module Assets
    class Asset

      def initialize(plugin, type, file)
        @file = file
        @type = type
        @plugin = plugin
        @plugin_type = plugin.type
        @root = plugin.assets_path
        @dir = File.join(plugin.namespace, type)
        @exists = {}
      end

      def file
        @file
      end

      def path(site)
        file = user_path(site)

        if !exists?(file) && @plugin_type != 'local_plugin'
          file = plugin_path 
        end

        unless exists? file
          raise IOError.new "Could not find #{File.basename(file)} at #{file}"
        end
        Pathname.new file
      end

      def file(file, site)
        @file = file
        path(site)
      end

      def destination
        File.join(@dir, @file)
      end

      def copy(site)
        site.static_files << StaticFile.new(path(site), destination)
      end

      def plugin_dir
        File.join @root, @type
      end

      def plugin_path
        File.join plugin_dir, @file
      end

      def user_dir(site)
        File.join site.source, Plugins.custom_dir(site), @dir
      end

      def user_path(site)
        if @plugin_type == 'local_plugin'
          File.join site.source, @dir, @file
        else
          File.join user_dir(site), @file
        end
      end

      def exists?(file)
        @exists[file] ||= File.exists?(file)
        @exists[file]
      end
    end
  end
end
