# Inspired by jekyll-contentblocks https://github.com/rustygeldmacher/jekyll-contentblocks
#
module Octopress
  module Tags
    class YieldTag < Liquid::Tag

      def initialize(tag_name, markup, tokens)
        super
        @markup = markup
        if markup =~ Helpers::Var::HAS_FILTERS
          markup = $1
          @filters = $2
        end
        @block_name = Helpers::ContentFor.get_block_name(tag_name, markup)
      end

      def render(context)
        markup = Helpers::Conditional.parse(@markup, context)
        return unless markup
        content = Helpers::ContentFor.render(context, @block_name)

        unless content.nil? || @filters.nil?
          content = Helpers::Var.render_filters(content, @filters, context)
        end

        if @block_name == 'head' && ENV['OCTOPRESS_ENV'] != 'TEST'
          content.insert 0, "<meta name='generator' content='Octopress #{Octopress::Ink::VERSION}'>"
        end

        content
      end
    end
  end
end
