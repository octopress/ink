module Octopress
  module Tags
    class JavascriptTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
      end
      def render(context)
        site = context.registers[:site]
        Plugins.javascript_tags(site)
      end
    end
  end
end

