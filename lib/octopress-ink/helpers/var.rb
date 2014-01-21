module Octopress
  module Helpers
    module Var
      TERNARY = /(.*?)\(\s*(.+?)\s+\?\s+(.+?)\s+:\s+(.+?)\s*\)(.+)?/

      def self.set_var(var, operator, value, context)
        case operator
        when '||='
          context.scopes.last[var] = value if context.scopes.last[var].nil?
        when '+='
          if context.scopes.last[var].nil?
            context.scopes.last[var] = value
          else
            context.scopes.last[var] += value
          end
        else
          context.scopes.last[var] = value
        end
        context
      end

      def self.get_value(vars, context)
        if vars =~ TERNARY
          vars = $1 + evaluate_ternary($2, $3, $4, context) + $5
        end
        vars = vars.strip.gsub(/ or /, ' || ')
        vars = vars.split(/ \|\| /).map { |v|
          Liquid::Variable.new(v.strip).render(context)
        }.compact

        vars.empty? ? nil : vars.first
      end

      def self.evaluate_ternary(expression, if_true, if_false, context)
        Conditional.parse("if #{expression}", context) ? if_true : if_false
      end

    end
  end
end

