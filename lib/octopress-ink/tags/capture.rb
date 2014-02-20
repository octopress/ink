module Octopress
  module Ink
    module Tags
      class CaptureTag < Liquid::Block
        SYNTAX = /([[:word:]]+)\s*(\+=|\|\|=)?/o

        def initialize(tag_name, markup, tokens)
          @markup = markup
          super
        end

        def render(context)
          return unless markup = Helpers::Conditional.parse(@markup, context)
          if markup =~ Helpers::Var::HAS_FILTERS
            markup = $1
            filters = $2
          end

          if markup =~ SYNTAX
            var      = $1
            operator = $2
            value = super.lstrip

            unless value.nil? || filters.nil?
              value = Helpers::Var.render_filters(value, filters, context)
            end

            context = Helpers::Var.set_var(var, operator, value, context)
          else
            raise SyntaxError.new("Syntax Error in 'capture' - Valid syntax: capture [var]")
          end
          ''
        end
      end
    end
  end
end

