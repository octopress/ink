# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
module Octopress
  module Ink
    module Tags
      class ContentForTag < Liquid::Block

        def initialize(tag_name, markup, tokens)
          super
          @tag_name = tag_name
          @markup   = markup
        end

        def render(context)
          return unless markup = TagHelpers::Conditional.parse(@markup, context)

          @block_name ||= TagHelpers::ContentFor.get_block_name(@tag_name, markup)
          TagHelpers::ContentFor.append_to_block(context, @block_name, super)
          ''
        end
      end
    end
  end
end

