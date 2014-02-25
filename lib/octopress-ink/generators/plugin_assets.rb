module Octopress
  module Ink
    class PluginAssets < Jekyll::Generator
      def generate(site)
        Plugins.register site
        Plugins.add_files
        site = Plugins.site
      end
    end
  end
end

