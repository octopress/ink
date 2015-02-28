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


          # If no input is passed, render in context of current page
          # This allows the tag to be used without input on post templates
          # But in a page loop it should be told passed the post item
          #

          page = context[@input] || context['page']
          items = page[item_name_plural]

          return '' if items.nil? || items.empty?

          items = items.sort.map do |item|
            link = item_link(page, item)

            if item_list?
              link = "<li class='#{item_type}-list-item'>#{link}</li>"
            end

            link
          end

          if item_list?
            "<ul class='#{item_name}-list'>#{items.join}</ul>"
          else
            "<span class='#{item_name}-links'>#{items.join(', ')}</span>"
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
          dir = Octopress::Ink::Bootstrap.permalink(item_name, item, page['lang'])
          path = File.join(@context['site']['baseurl'], dir)
          "<a class='#{item_name}-link' href='#{path}'>#{item.capitalize}</a>"
        end
      end
    end
  end
end
