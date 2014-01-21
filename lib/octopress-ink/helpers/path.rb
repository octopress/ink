module Octopress
  module Helpers
    module Path
      FILE = /(\S+)(\s.+)/
      def self.parse(markup, context)
        if markup =~ FILE
          (context[$1].nil? ? $1 : context[$1]) + $2
        else
          markup
        end
      end
    end
  end
end
