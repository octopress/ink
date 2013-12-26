module ThemeKit
  class JavascriptTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end
    def render(context)
      Template.theme.javascript_tags(context.registers[:site])
    end
  end
end
