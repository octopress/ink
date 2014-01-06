module Octopress
  module Tags
    class HeadBlock < ContentForBlock
      def initialize(tag_name, markup, tokens)
        @block_name = 'head'
        super
      end
    end
  end
end
