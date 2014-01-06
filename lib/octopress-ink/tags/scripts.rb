module Octopress
  module Tags
    class ScriptsBlock < ContentForBlock
      def initialize(tag_name, markup, tokens)
        @block_name = 'scripts'
        super
      end
    end
  end
end
