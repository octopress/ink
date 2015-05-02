module Octopress
  module Ink
    module Commands
      module CommandHelpers
        def self.add_asset_options(c, action)
          c.option "config-file", "-c", "--config", "#{action} plugin's config file"
          c.option "layouts", "-l", "--layouts", "#{action} only layouts"
          c.option "includes", "-i", "--includes", "#{action} only includes"
          c.option "pages", "-p", "--pages", "#{action} only pages"
          c.option "templates", "-t", "--templates", "#{action} only pages"
          c.option "stylesheets", "-s", "--stylesheets", "#{action} only Stylesheets (.css, .scss, .sass)"
          c.option "css", "--css", "#{action} only CSS files (.css)"
          c.option "sass", "--sass", "#{action} only Sass files (.scss, .sass)"
          c.option "javascripts", "-j", "--javascripts", "#{action} only Javascripts (.js and .coffee)"
          c.option "js", "--js", "#{action} only Javascript files (.js)"
          c.option "coffee", "--coffee", "#{action} only Coffeescript files (.coffee)"
          c.option "images", "-I", "--images", "#{action} only images"
          c.option "fonts", "--fonts", "#{action} only fonts"
          c.option "files", "--files", "#{action} only files"
        end
      end
    end
  end
end

