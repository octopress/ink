module Octopress
  module Helpers
    module Conditional
      SYNTAX = /(.*)(if|unless)\s*(.+)/

      def self.parse(markup, context)
        if markup =~ SYNTAX
          case $2
          when 'if'
            tag = Liquid::If.new('if', $3, ["true","{% endif %}"])
          when 'unless'
            tag = Liquid::Unless.new('unless', $3, ["true","{% endunless %}"])
          end
          tag.render(context) != '' ? $1 : false
        else
          markup
        end
      end

    end
  end
end
