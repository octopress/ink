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

  class DoLayoutTag < Liquid::Block
    CONTENT = /(.*?)({{\s*content\s*}})(.*)/im

    def initialize(tag_name, markup, tokens)
      @tag = tag_name
      @file = markup.strip
      super
    end

    def render(context)
      content = super.strip
      layout = Render.read(@file, context.registers[:site])
      if layout =~ CONTENT
        content = $1 + content + $3
      else
        content
      end
      partial = Liquid::Template.parse(content)
      content = context.stack { 
        partial.render!(context) 
      }.strip
    end
  end
end

module Jekyll
  class ThemeKitHooks < PageHooks

    # Manipulate page/post data before it has been processed with Liquid or
    # Converters like Markdown or Textile.
    #
    def pre_render(page)
      if page.data['theme_layout']
        page.content = "{% do_layout #{page.data['theme_layout']} %}#{page.content}{% enddo_layout %}"
      end
    end
  end
end
