module Octopress
  module Ink
    module Tags
      class CategoryTag < Liquid::Tag
        def initialize(tag, input, tokens)
          super
          @tag    = tag
          if !input.nil?
            @input  = input.strip
          end
        end

        def render(context)
          @context = context

          # Check to see if post loop is active, otherwise default to current page
          page = context['post'] || context['page']

          tags = Bootstrap.send(@tag)[page['url']]

          if tags.nil?
            if tags = item_tags(page)
              # Cache tags to speed up multiple references for the same post
              Bootstrap.send(@tag)[page['url']] = tags
            end
          end

          tags
        end

        def item_tags(page)
          items = page[item_name_plural]

          return nil if items.nil? || items.empty?

          items = items.sort.map { |i| item_link(page, i) }.compact.map do |link|
            if item_list?
              link = %Q{<li class="#{item_name}-list-item">#{link}</li>}
            end

            link
          end

          return nil if items.empty?

          if item_list?
            %Q{<ul class="#{item_name}-list">#{items.join}</ul>}
          else
            %Q{<span class="#{item_name}-links">#{items.join(', ')}</span>}
          end
        end

        def item_list?
          @tag.end_with? '_list'
        end

        def item_name
          @tag.match('tag') ? 'tag' : 'category'
        end

        def item_name_plural
          @tag.match('tag') ? 'tags' : 'categories'
        end

        def item_link(page, item)
          if dir = Bootstrap.send(item_name, item, page['lang'])
            path = File.join(@context['site']['baseurl'] || '', dir)
            %Q{<a class="#{item_name}-link" href="#{path}">#{item.capitalize}</a>}
          end
        end
      end
    end
  end
end
