module Octopress
  module Tags
    class CaptureTag < Liquid::Block
      SYNTAX = /([[:word:]]+)\s*(\+=|\|\|=)?/o

      def initialize(tag_name, markup, tokens)
        @markup = markup
        super
      end

      def render(context)
        markup = Helpers::Conditional.parse(@markup, context)
        return unless markup

        if markup =~ SYNTAX
          var      = $1
          operator = $2
          value = super.lstrip

          context = Helpers::Var.set_var(var, operator, value, context)
        else
          raise SyntaxError.new("Syntax Error in 'capture' - Valid syntax: capture [var]")
        end
        ''
      end
    end
  end
end

