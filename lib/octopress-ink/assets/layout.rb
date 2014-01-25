module Octopress
  module Assets
    class Layout < Asset

      def register
        name = "#{@plugin.namespace}:#{@file}"
        name = name.split(".")[0..-2].join(".")

        file = user_path
        dir = user_dir
        if !exists?(file)
          file = plugin_path 
          dir = plugin_dir
        end

        Plugins.site.layouts[name] = Jekyll::Layout.new(Plugins.site, dir, @file)
      end
    end
  end
end

