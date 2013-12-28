module ThemeKit
  class StylesheetTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end
    def render(context)
      site = context.registers[:site]
      if site.config['octopress'] && site.config['octopress']['combine_stylesheets'] != false
        Plugins.stylesheet_tags
      else
        Plugins.combined_stylesheet_tag(site)
      end
    end
  end
end
