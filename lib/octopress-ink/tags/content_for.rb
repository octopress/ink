# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
module Octopress
  module Tags
    class ContentForBlock < Liquid::Block

      def initialize(tag_name, markup, tokens)
        super
        @tag_name = tag_name
        @markup   = markup
      end

      def render(context)
        if @markup =~ Helpers::Conditional::SYNTAX
          return unless Helpers::Conditional.parse(@markup, context)
          @markup = $1
        end

        @block_name ||= Helpers::ContentFor.get_block_name(@tag_name, @markup)
        Helpers::ContentFor.append_to_block(context, @block_name, super)
        ''
      end
    end
  end
end
