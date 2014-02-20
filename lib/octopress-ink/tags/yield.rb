# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Ink
    module Tags
      class YieldTag < Liquid::Tag

        def initialize(tag_name, markup, tokens)
          if markup.strip == ''
            raise IOError.new "Yield failed: {% #{tag_name} #{markup}%}. Please provide a block name to yield. - Syntax: {% yield block_name %}"
          end

          super
          @markup = markup
          if markup =~ Helpers::Var::HAS_FILTERS
            markup = $1
            @filters = $2
          end
          @block_name = Helpers::ContentFor.get_block_name(tag_name, markup)
        end

        def render(context)
          return unless markup = Helpers::Conditional.parse(@markup, context)
          content = Helpers::ContentFor.render(context, @block_name)

          unless content.nil? || @filters.nil?
            content = Helpers::Var.render_filters(content, @filters, context)
          end

          content
        end
      end
    end
  end
end

