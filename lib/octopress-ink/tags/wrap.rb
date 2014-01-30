# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Tags
    class WrapTag < Liquid::Block

      def initialize(tag_name, markup, tokens)
        super
        @og_markup = @markup = markup
        @tag_name = tag_name
      end

      def render(context)
        require 'pry-debugger'
        markup = Helpers::Conditional.parse(@markup, context)
        return unless markup

        case @tag_name
        when 'wrap_yield'
          content = Tags::YieldTag.new('yield', markup, []).render(context)
        when 'wrap_render'
          begin
            content = Tags::RenderTag.new('render', markup, []).render(context)
          rescue => error
            error_msg error
          end
        when 'wrap'
          begin
            content = Tags::IncludeTag.new('include', markup, []).render(context)
          rescue => error
            error_msg error
          end
        end

        context.scopes.first['yield'] = content
        super.strip
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

