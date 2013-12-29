module ThemeKit
  class PluginAssets < Jekyll::Generator
    def generate(site)

      # Copy/Generate Stylesheets
      #
      if site.config['octopress'] && site.config['octopress']['combine_stylesheets'] != false
        Plugins.copy_stylesheets(site)
      else
        Plugins.write_combined_stylesheet(site)
      end

      # Copy/Generate Javascripts
      #
      if site.config['octopress'] && site.config['octopress']['combine_javascripts'] != false
        Plugins.copy_javascripts(site)
      else
        Plugins.write_combined_javascript(site)
      end

      # Copy other assets
      #
      Plugins.copy_images(site)
      Plugins.copy_fonts(site)
      Plugins.copy_files(site)
    end
  end
end

