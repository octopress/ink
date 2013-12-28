module ThemeKit
  class Stylesheets < Jekyll::Generator
    def generate(site)
      if site.config['octopress'] && site.config['octopress']['combine_stylesheets'] != false
        Plugins.copy_stylesheets(site)
      else
        Plugins.write_combined_stylesheet(site)
      end
    end
  end
end
