module ThemeKit
  class Javascripts < Jekyll::Generator
    def generate(site)
      if site.config['octopress'] && site.config['octopress']['combine_javascripts'] != false
        Plugins.copy_javascripts(site)
      else
        Plugins.write_combined_javascript(site)
      end
    end
  end
end
