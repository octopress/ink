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
        markup = Helpers::Conditional.parse(@markup, context)
        return unless markup

        case @tag_name
        when 'wrap_yield'
          content = content_for(markup, context)
        when 'wrap_render'
          begin
            content = include_tag = Octopress::Tags::RenderTag.new('render', markup, []).render(context)
          rescue => error
            error_msg error
          end
        when 'wrap'
          begin
            content = include_tag = Octopress::Tags::IncludeTag.new('include', markup, []).render(context)
          rescue => error
            error_msg error
          end
        end

        wrap = super.strip

        if wrap =~ HAS_YIELD && content != ''
          $1 + content + $3
        else
          ''
        end
      end

      def error_msg(error)
        error.message
        message = "Wrap failed: {% #{@tag_name} #{@og_markup}%}."
        message << $1 if error.message =~ /%}\.(.+)/
        raise IOError.new message
      end

      def content_for(markup, context)
        @block_name = Helpers::ContentFor.get_block_name(@tag_name, markup)
        Helpers::ContentFor.render(context, @block_name).strip
      end
    end
  end
end

