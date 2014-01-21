# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Tags
    class YieldTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
        @block_name = Helpers::ContentFor.get_block_name(tag_name, markup)
      end

      def render(context)
        markup = Helpers::Conditional.parse(@markup, context)
        return unless markup

        content = Helpers::ContentFor.render(context, @block_name)
        if @block_name == 'head'
          content.insert 0, "<meta name='generator' content='Octopress #{Octopress::Ink::VERSION}'>\n"
        end
        content
      end
    end
  end
end
