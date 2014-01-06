module Octopress
  module Assets
    class Layout < Asset

      def file(file, site)
        @file = file
      end

      def register(site)
        name = "#{@plugin.namespace}:#{@file}"
        name = name.split(".")[0..-2].join(".")

        file = user_path(site)
        dir = user_dir(site)
        if !exists?(file)
          file = plugin_path 
          dir = plugin_dir
        end

        site.layouts[name] = Jekyll::Layout.new(site, dir, @file)
      end
    end
  end
end

