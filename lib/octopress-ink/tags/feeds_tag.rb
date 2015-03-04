module Octopress
  module Ink
    module Tags
      class FeedsTag < Liquid::Tag
        def render(context)
          tags = []
          Bootstrap.feeds.each do |url, title|
            tags << tag(url, title)
          end
          tags.join("\n")
        end

        def tag(url, title)
          %Q{<link href="#{File.join('/', Octopress.site.config['baseurl'], url).sub('index.xml', '')}" title="#{title}" rel="alternate" type="application/atom+xml">}
        end
      end
    end
  end
end
