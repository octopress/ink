module Octopress
  module Ink
    module Tags
      class IncludeTag < Liquid::Tag
        PLUGIN_SYNTAX = /(.+?):(\S+)/

        def initialize(tag_name, markup, tokens)
          super
          @og_markup = @markup = markup
        end

        def render(context)
          return unless markup = TagHelpers::Conditional.parse(@markup, context)
          if markup =~ TagHelpers::Var::HAS_FILTERS
            markup = $1
            filters = $2
          end
          markup = TagHelpers::Var.evaluate_ternary(markup, context)
          markup = TagHelpers::Path.parse(markup, context)

          include_tag = Jekyll::Tags::IncludeTag.new('include', markup, [])

          # If markup references a plugin e.g. plugin-name:include-file.html
          if markup.strip =~ PLUGIN_SYNTAX
            plugin = $1
            path = $2
            begin
              content = Octopress::Ink::Plugins.include(plugin, path).read
            rescue => error
              msg = "Include failed: {% #{@tag_name} #{@og_markup}%}.\n"
              if !defined?(Octopress::Ink)
                msg += "The plugin '#{plugin}' does not have an include named '#{path}'."
              else
                msg += "To include plugin partials, first install Octopress Ink."
              end
              raise IOError.new(msg)
            end
            partial = Liquid::Template.parse(content)
            content = context.stack {
              context['include'] = include_tag.parse_params(context)
              partial.render!(context)
            }.strip
            
          # Otherwise, use Jekyll's default include tag
          else
            content = include_tag.render(context).strip
          end

          unless content.nil? || filters.nil?
            content = TagHelpers::Var.render_filters(content, filters, context)
          end

          content
        end
      end
    end
  end
end

