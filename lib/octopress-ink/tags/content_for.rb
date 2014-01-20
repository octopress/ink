# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
module Octopress
  module Tags
    class ContentForBlock < Liquid::Block

      def initialize(tag_name, markup, tokens)
        super
        @block_name ||= Helpers::ContentFor.get_block_name(tag_name, markup)
      end

      def render(context)
        Helpers::ContentFor.append_to_block(context, @block_name, super)
        ''
      end
    end
  end
end
