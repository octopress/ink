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
        content = Helpers::ContentFor.render(context, @block_name)
        if @block_name == 'head'
          content = "<meta name='generator' content='Octopress #{Octopress::Ink::VERSION}'>\n" + content
        end
        content
      end
    end
  end
end
