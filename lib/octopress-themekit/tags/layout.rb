require File.join File.expand_path('../../', __FILE__), 'helpers/render'

module ThemeKit
  class LayoutTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @file = markup.strip
      super
    end
    def render(context)
      Render.render('layout', @file, context)
    end
  end
end

