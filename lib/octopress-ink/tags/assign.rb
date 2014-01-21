module Octopress
  module Tags
    class AssignTag < Liquid::Tag
      SYNTAX = /([[:word:]]+)\s*(=|\+=|\|\|=)\s*(.*)\s*/o

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
          value    = $3

          value = Helpers::Var.get_value(value, context)
          return if value.nil?

          context = Helpers::Var.set_var(var, operator, value, context)
        else
          raise SyntaxError.new("Syntax Error in 'assign' - Valid syntax: assign [var] = [source]")
        end
        ''
      end
    end
  end
end

