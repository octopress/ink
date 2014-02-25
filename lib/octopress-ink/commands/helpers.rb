module Octopress
  module Ink
    module Commands
      module CommandHelpers
        def self.add_asset_options(c)
          c.option "layouts", "--layouts", "List only layouts"
          c.option "includes", "--includes", "List only includes"
          c.option "pages", "--pages", "List only pages"
          c.option "stylesheets", "--stylesheets", "List only stylesheets"
          c.option "sass", "--sass", "List only Sass files"
          c.option "javascripts", "--javascripts", "List only Javascripts"
          c.option "images", "--images", "List only images"
          c.option "fonts", "--fonts", "List only fonts"
          c.option "files", "--files", "List only files"
          c.option "config", "--config <CONFIG_FILE>[,CONFIG_FILE2,...]", Array, "Custom configuration file"
        end
      end
    end
  end
end
