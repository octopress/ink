module Octopress
  module Ink
    module Tags
      class FilterTag < Liquid::Block
        def initialize(tag_name, markup, tokens)
          super
          @markup = " #{markup}"
        end

        def render(context)
          content = super.strip

          return content unless markup = TagHelpers::Conditional.parse(@markup, context)
          if markup =~ TagHelpers::Var::HAS_FILTERS and !content.nil?
            content = TagHelpers::Var.render_filters(content, $2, context)
          end

          content
        end
      end
    end
  end
end

