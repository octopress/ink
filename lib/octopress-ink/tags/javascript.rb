module Octopress
  module Tags
    class JavascriptTag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super
      end
      def render(context)
        site = context.registers[:site]
        if site.config['octopress'] && site.config['octopress']['combine_javascripts'] != false
          Plugins.javascript_tags
        else
          Plugins.combined_javascript_tag(site)
        end
      end
    end
  end
end

