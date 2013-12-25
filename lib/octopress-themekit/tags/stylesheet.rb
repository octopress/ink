module ThemeKit
  class StylesheetTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end
    def render(context)
      Template.theme.stylesheet_tag(context.registers[:site])
    end
  end
end
