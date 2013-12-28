module ThemeKit
  class DoLayoutTag < Liquid::Block
    CONTENT = /(.*?)({{\s*content\s*}})(.*)/im
    YAML_HEADER = /\A-{3}(.+[^\A])-{3}\n(.+)/m
    LAYOUT_VAR = /(.+?)\/(.*)/

    def initialize(tag_name, markup, tokens)
      @tag = tag_name
      @plugin, @file = markup.strip.split(' ')
      super
    end

    def render(context)
      content = wrap_layout(@file, super.strip, context.registers[:site])

      context.stack { 
        Liquid::Template.parse(content).render!(context) 
      }.strip
    end

    def read_layout(file, site)
      content = Plugins.layout(@plugin, file, site).read

      if content =~ YAML_HEADER
        vars = YAML.safe_load($1)
        content = $2.strip
        content = wrap_layout(layout_var(vars), content, site)
      end

      content
    end

    def wrap_layout(file, content, site)
      file += '.html' unless file =~ /\.html$/
      if read_layout(file, site) =~ CONTENT
        $1 + content + $3
      else
        content
      end
    end

    def layout_var(vars)
      if vars['theme_layout']
        vars['theme_layout']
      elsif vars['plugin_layout'] =~ LAYOUT_VAR
        @plugin = $1
        $2
      end
    end
  end
end

module Jekyll
  class ThemeKitHooks < PageHooks

    # Manipulate page/post data before it has been processed with Liquid or
    # Converters like Markdown or Textile.
    #
    def pre_render(page)
      data = page.data
      if data['theme_layout']
        page.content = "{% do_layout theme #{data['theme_layout']} %}#{page.content}{% enddo_layout %}"
      elsif data['plugin_layout'] =~ 
        page.content = "{% do_layout #{$1} #{$2} %}#{page.content}{% enddo_layout %}"
      end
    end
  end
end
