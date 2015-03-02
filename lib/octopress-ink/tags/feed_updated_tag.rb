module Octopress
  module Ink
    module Tags
      class FeedUpdatedTag < Liquid::Tag
        def render(context)
          feed = context['page.feed_type']
          site = context['site']

          if feed == 'category'
            posts = site['categories'][context['page.category']]
          else
            posts = site[feed] || site['posts']
          end

          if posts && !posts.empty?
            post = posts.sort_by do |p|
              p.data['date_updated'] || p.date
            end.last

            post.data['date_updated_xml'] || post.data['date_xml']
          end
        end
      end
    end
  end
end
