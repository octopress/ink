# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Tags
    class WrapTag < Liquid::Block
      HAS_YIELD = /(.*?)({=\s*yield\s*})(.*)/im
      def initialize(tag_name, markup, tokens)
        super
        @og_markup = @markup = markup
        @tag_name = tag_name
      end

      def render(context)
        if @markup =~ Helpers::Conditional::SYNTAX
          return unless Helpers::Conditional.parse(@markup, context)
          @markup = $1
        end
        case @tag_name
        when 'wrap_yield'
          content = content_for(context)
        when 'wrap'
          begin
            content = include_tag = Octopress::Tags::IncludeTag.new('include', @markup, []).render(context)
          rescue => error
            error.message
            message = "Wrap failed: {% #{@tag_name} #{@og_markup}%}."
            message << $1 if error.message =~ /%}\.(.+)/
            raise IOError.new message
          end
        end

        wrap = super.strip

        if wrap =~ HAS_YIELD && content != ''
          $1 + content + $3
        else
          ''
        end
      end

      def content_for(context)
        @block_name = Helpers::ContentFor.get_block_name(@tag_name, @markup)
        Helpers::ContentFor.render(context, @block_name).strip
      end
    end
  end
end

