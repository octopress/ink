module Octopress
  module Tags
    class IncludeTag < Liquid::Tag
      PLUGIN_SYNTAX = /(.+?):(\S+)/

      def initialize(tag_name, markup, tokens)
        super
        @markup = markup
      end

      def render(context)
        include_tag = Jekyll::Tags::IncludeTag.new('include', @markup, [])

        # If markup references a plugin e.g. plugin-name:include-file.html
        if @markup.strip =~ PLUGIN_SYNTAX
          plugin = $1
          path = $2
          content = Plugins.include(plugin, path, context.registers[:site]).read
          partial = Liquid::Template.parse(content)
          context.stack {
            context['include'] = include_tag.parse_params(context)
            partial.render!(context)
          }.strip
        # Otherwise, use Jekyll's default include tag
        else
          include_tag.render(context)
        end
      end
    end
  end
end

