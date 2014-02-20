module Octopress
  module Ink
    class PluginAssets < Jekyll::Generator
      def generate(site)
        Plugins.site = site
        Plugins.register_layouts
        Plugins.add_static_files
        site = Plugins.site
      end
    end
  end
end

