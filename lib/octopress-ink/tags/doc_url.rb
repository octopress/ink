# For plugin authors who need to generate urls pointing to ther doc pages.

module Octopress
  module Ink
    module Tags
      class DocUrlTag < Liquid::Tag
        def initialize(tag_name, markup, tokens)
          super
          @url = markup.strip
        end

        def render(context)
          '/' + File.join(context['page']['plugin']['docs_base_path'], @url)
        end
      end
    end
  end
end
