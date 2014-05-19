module Octopress
  module Ink
    class PluginAssets < Jekyll::Generator
      def generate(site)
        Ink.site = site
        Plugins.register
        Plugins.add_files
        site = Ink.site
      end
    end
  end
end

