require 'pry-debugger'

CONTENT = /(.*?)({{\s*content\s*}})(.*)/im

module ThemeKit
  module Render
    def self.render(tag, file, context)
      @tag = tag
      partial = Liquid::Template.parse(read(file, context.registers[:site]))
      context.stack { 
        context['page'] = context['page'].deep_merge(@local_vars) if @local_vars and @local_vars.keys.size > 0
        partial.render!(context) 
      }.strip
    end

  end
end

