module Octopress
  module Tags
    class ReturnTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        @markup = markup.strip
        super
      end

      def render(context)
        markup = Helpers::Conditional.parse(@markup, context)
        return unless markup

        Helpers::Var.get_value(markup, context)
      end
    end
  end
end
