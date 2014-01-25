module Octopress
  class PluginAssets < Jekyll::Generator
    def generate(site)
      Plugins.config(site)
      Plugins.register_layouts
      Plugins.add_static_files
      site = Plugins.site
    end
  end
end

