module Octopress
  module Ink
    module Commands
      module CommandHelpers
        def self.add_asset_options(c, action)
          c.option "config-file", "--config-file", "#{action} plugin's default configuration"
          c.option "layouts", "--layouts", "#{action} only layouts"
          c.option "includes", "--includes", "#{action} only includes"
          c.option "pages", "--pages", "#{action} only pages"
          c.option "stylesheets", "--stylesheets", "#{action} only Stylesheets (.css, .scss, .sass)"
          c.option "css", "--css", "#{action} only CSS files (.css)"
          c.option "sass", "--sass", "#{action} only Sass files (.scss, .sass)"
          c.option "javascripts", "--javascripts", "#{action} only Javascripts (.js and .coffee)"
          c.option "js", "--js", "#{action} only Javascript files (.js)"
          c.option "coffee", "--coffee", "#{action} only Coffeescript files (.coffee)"
          c.option "images", "--images", "#{action} only images"
          c.option "fonts", "--fonts", "#{action} only fonts"
          c.option "files", "--files", "#{action} only files"
          unless action.downcase == 'copy'
            c.option "config", "--config <CONFIG_FILE>[,CONFIG_FILE2,...]", Array, "Custom Jekyll configuration file"
          end
        end
      end
    end
  end
end

