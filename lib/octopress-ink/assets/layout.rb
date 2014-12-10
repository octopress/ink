module Octopress
  module Ink
    module Assets
      class Layout < Asset

        def initialize(plugin, base, file)
          super
          register
        end

        private

        def register
          dir = user_dir
          if !exists?(File.join(dir, file))
            dir = plugin_dir
          end

          Octopress.site.layouts[name] = Ink::Layout.new(Octopress.site, dir, file)
        end

        def name
          name = "#{plugin.slug}:#{file}"
          # remove extension
          name = name.split(".")[0..-2].join(".")
        end
      end
    end
  end
end

