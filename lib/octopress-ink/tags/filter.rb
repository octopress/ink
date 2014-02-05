module Octopress
  module Tags
    class FilterTag < Liquid::Block
      def initialize(tag_name, markup, tokens)
        super
        @markup = " #{markup}"
      end

      def render(context)
        content = super.strip

        return content unless markup = Helpers::Conditional.parse(@markup, context)
        if markup =~ Helpers::Var::HAS_FILTERS and !content.nil?
          content = Helpers::Var.render_filters(content, $2, context)
        end

        content
      end
    end
  end
end
