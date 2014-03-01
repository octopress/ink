module Octopress
  module Ink
    module Commands
      module CommandHelpers
        def self.add_asset_options(c, action)
          c.option "layouts", "--layouts", "#{action} only layouts"
          c.option "includes", "--includes", "#{action} only includes"
          c.option "pages", "--pages", "#{action} only pages"
          c.option "stylesheets", "--stylesheets", "#{action} only Stylesheets"
          c.option "sass", "--sass", "#{action} only Sass files"
          c.option "javascripts", "--javascripts", "#{action} only Javascripts"
          c.option "images", "--images", "#{action} only images"
          c.option "fonts", "--fonts", "#{action} only fonts"
          c.option "files", "--files", "#{action} only files"
          c.option "config", "--config <CONFIG_FILE>[,CONFIG_FILE2,...]", Array, "Custom configuration file"
        end
      end
    end
  end
end

