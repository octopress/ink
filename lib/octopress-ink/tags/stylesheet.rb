module Octopress
  module Tags
    class StylesheetTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
      end
      def render(context)
        site = context.registers[:site]
        Plugins.stylesheet_tags(site)
      end
    end
  end
end

