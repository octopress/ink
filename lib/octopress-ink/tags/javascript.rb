module Octopress
  module Ink
    module Tags
      class JavascriptTag < Liquid::Tag
        def render(context)
          Plugins.js_tags
        end
      end
    end
  end
end

