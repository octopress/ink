# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Tags
    class WrapYieldBlock < Liquid::Block
      HAS_YIELD = /(.*?)({=\s*yield\s*})(.*)/im
      def initialize(tag_name, markup, tokens)
        super
        @markup = markup
        @tag_name = tag_name
      end

      def render(context)
        if @markup =~ Helpers::Conditional::SYNTAX
          return unless Helpers::Conditional.parse(@markup, context)
          @markup = $1
        end

        @block_name = Helpers::ContentFor.get_block_name(@tag_name, @markup)

        wrap = super.strip
        content = Helpers::ContentFor.render(context, @block_name).strip

        if wrap =~ HAS_YIELD && content != ''
          $1 + content + $3
        else
          ''
        end
      end
    end
  end
end

