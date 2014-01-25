module Octopress
  module Tags
    class StylesheetTag < Liquid::Tag
      def render(context)
        Plugins.stylesheet_tags
      end
    end
  end
end

