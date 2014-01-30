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
        return unless markup = Helpers::Conditional.parse(@markup, context)

        type = if markup =~ /^\s*yield\s(.+)/
          markup = $1
          'yield'
        elsif markup =~ /^\s*render\s(.+)/
          markup = $1
          'render'
        elsif markup =~ /^\s*include\s(.+)/
          markup = $1
          'include'
        else
          raise IOError.new "Wrap Failed: {% wrap #{@og_markup}%} - Which type of wrap: inlcude, yield, render? - Correct syntax: {% wrap type path or var [filters] [conditions] %}"
        end

        case type
        when 'yield'
          content = Tags::YieldTag.new('yield', markup, []).render(context)
        when 'render'
          begin
            content = Tags::RenderTag.new('render', markup, []).render(context)
          rescue => error
            error_msg error
          end
        when 'include'
          begin
            content = Tags::IncludeTag.new('include', markup, []).render(context)
          rescue => error
            error_msg error
          end
        end

        # just in case yield had a value
        old_yield = context.scopes.first['yield']
        context.scopes.first['yield'] = content
        
        content = super.strip
        context.scopes.first['yield'] = old_yield

        content
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

