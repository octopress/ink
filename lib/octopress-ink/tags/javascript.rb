module Octopress
  module Tags
    class JavascriptTag < Liquid::Tag
      def render(context)
        Plugins.javascript_tags
      end
    end
  end
end

