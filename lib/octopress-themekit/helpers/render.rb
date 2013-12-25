require 'pry-debugger'

CONTENT = /(.*?)({{\s*content\s*}})(.*)/im
YAML_HEADER = /\A-{3}(.+[^\A])-{3}\n(.+)/m

module ThemeKit
  module Render
    def self.render(tag, file, context)
      @tag = tag
      partial = Liquid::Template.parse(read(file, context.registers[:site]))
      binding.pry
      context.stack { 
        context['page'] = context['page'].deep_merge(@local_vars) if @local_vars and @local_vars.keys.size > 0
        partial.render!(context) 
      }.strip
    end

    def self.read(file, site)
      file += '.html' unless file =~ /\.html$/
      content = Template.theme.layout(file, site).read
      if content =~ YAML_HEADER
        layout = YAML.safe_load($1.strip)['layout']
        content = $2.strip
        content = wrap_layout(layout, content, site)
      end
      content
    end

    def self.wrap_layout(layout, content, site)
      if layout
        layout = read(layout, site)
        if layout =~ CONTENT
          $1 + content + $3
        end
      else
        content
      end
    end
  end
end

