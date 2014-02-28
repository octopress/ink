module Octopress
  module Ink
    module Assets
      class Layout < Asset

        def initialize(plugin, base, file)
          super
          register
        end

        def register
          file = user_path
          dir = user_dir
          if !exists?(file)
            file = plugin_path 
            dir = plugin_dir
          end

          Plugins.site.layouts[name] = Jekyll::Layout.new(Plugins.site, dir, @file)
        end

        def name
          name = "#{@plugin.slug}:#{@file}"
          # remove extension
          name = name.split(".")[0..-2].join(".")
        end
      end
    end
  end
end

