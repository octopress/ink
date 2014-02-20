module Octopress
  module Ink
    module Tags
      class ReturnTag < Liquid::Tag
        def initialize(tag_name, markup, tokens)
          @markup = markup.strip
          super
        end

        def render(context)
          return unless markup = Helpers::Conditional.parse(@markup, context)

          Helpers::Var.get_value(markup, context)
        end
      end
    end
  end
end

