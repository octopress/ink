module Octopress
  module Tags
    class EmbedTag < Liquid::Tag
      EMBED_SYNTAX = /(.+?)\/(\S+)/

      def initialize(tag_name, markup, tokens)
        super
        @markup = markup
        if @markup.strip =~ EMBED_SYNTAX
          @plugin = $1
          @path = $2
        else
          raise IOError.new "Invalid Syntax: for embed tag. {% embed #{@markup.strip} %} should be {% embed plugin/file %}"
        end
      end

      def render(context)
        content = Plugins.embed(@plugin, @path, context.registers[:site]).read
        partial = Liquid::Template.parse(content)
        context.stack {
          context['embed'] = Jekyll::Tags::IncludeTag.new('include', @markup, []).parse_params(context)
          partial.render!(context)
        }.strip
      end
    end
  end
end

