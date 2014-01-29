module Octopress
  module Helpers
    module Var
      TERNARY = /(.*?)\(\s*(.+?)\s+\?\s+(.+?)\s+:\s+(.+?)\s*\)(.+)?/
      HAS_FILTERS = /(.+?)(\s+\|\s+.+)/

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
        vars = evaluate_ternary(vars, context)
        vars = vars.strip.gsub(/ or /, ' || ')
        filters = false
        if vars =~ HAS_FILTERS
          vars = $1
          filters = $2
        end
        vars = vars.split(/ \|\| /).map { |v|
          context[v.strip]
        }.compact

        var = vars.first
        if filters
          var = Liquid::Variable.new("'#{var}'"+ filters).render(context)
        end
        var
      end

      def self.evaluate_ternary(markup, context)
        if markup =~ TERNARY
          $1 + (Conditional.parse(" if #{$2}", context) ? $3 : $4) + $5
        else
          markup
        end
      end

      # Parses filters into arrays
      #
      # input - a string of one or more filters, e.g. "| upcase | replace:'a','b'" 
      #
      # Returns nested arrays of filters and arguments
      #
      def self.parse_filters(input)
        output = []
        if input.match(/#{Liquid::FilterSeparator}\s*(.*)/o)
          filters = Regexp.last_match(1).scan(Liquid::Variable::FilterParser)
          filters.each do |f|
            if matches = f.match(/\s*(\w+)/)
              filtername = matches[1]
              filterargs = f.scan(/(?:#{Liquid::FilterArgumentSeparator}|#{Liquid::ArgumentSeparator})\s*((?:\w+\s*\:\s*)?#{Liquid::QuotedFragment})/o).flatten
              output << [filtername, filterargs]
            end
          end
        end
        output
      end

      # Passes input through Liquid filters
      #
      # content - a string to be parsed
      # filters - a series of liquid filters e.g. "| upcase | replace:'a','b'"
      # context - the current Liquid context object
      #
      # Returns a filtered string
      #
      def self.render_filters(content, filters, context)
        filters = parse_filters(filters)
        return '' if content.nil?
        filters.inject(content) do |output, filter|
          filterargs = []
          keyword_args = {}
          filter[1].to_a.each do |a|
            if matches = a.match(/\A#{Liquid::TagAttributes}\z/o)
              keyword_args[matches[1]] = context[matches[2]]
            else
              filterargs << context[a]
            end
          end
          filterargs << keyword_args unless keyword_args.empty?
          begin
            output = context.invoke(filter[0], output, *filterargs)
          rescue
            raise "Error - filter '#{filter[0]}' could not be found."
          end
        end
      end
    end
  end
end

