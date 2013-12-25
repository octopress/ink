module ThemeKit
  class JavascriptTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super
    end
    def render(context)
      Template.theme.javascript_tag(context.registers[:site])
    end
  end
end
