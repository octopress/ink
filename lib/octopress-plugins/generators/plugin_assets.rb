module Octopress
  class PluginAssets < Jekyll::Generator
    def generate(site)
      Plugins.register_layouts(site)
      Plugins.add_static_files(site)
    end
  end
end

