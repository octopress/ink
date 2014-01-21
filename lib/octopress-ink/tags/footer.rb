module Octopress
  module Tags
    class FooterBlock < ContentForBlock
      def initialize(tag_name, markup, tokens)
        @block_name = 'footer'
        @markup = markup
        super
      end
    end
  end
end
