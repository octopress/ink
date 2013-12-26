module ThemeKit
  class StylesheetTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end
    def render(context)
      Plugins.stylesheet_tags(context.registers[:site])
    end
  end
end
