module Octopress
  module Tags
    class RenderTag < Liquid::Tag
      SYNTAX = /(\S+)(.+)?/

      def initialize(tag_name, markup, tokens)
        super
        @og_markup = @markup = markup
        if markup =~ /^(\s*raw\s)?(.+?)(\sraw\s*)?$/
          @markup = $2
          @raw = true unless $1.nil? and $3.nil?
        end
      end

      def render(context)
        return unless markup = Helpers::Conditional.parse(@markup, context)
        if markup =~ Helpers::Var::HAS_FILTERS
          markup = $1
          filters = $2
        end
        markup = Helpers::Var.evaluate_ternary(markup, context)
        markup = Helpers::Path.parse(markup, context)

        content = read(markup, context)

        if content =~ /\A-{3}(.+[^\A])-{3}\n(.+)/m
          local_vars = YAML.safe_load($1.strip)
          content = $2.strip
        end

        return content if @raw

        include_tag = Jekyll::Tags::IncludeTag.new('include', markup, [])

        partial = Liquid::Template.parse(content)
        content = context.stack {
          context['include'] = include_tag.parse_params(context)
          context['page'] = context['page'].deep_merge(local_vars) if local_vars
          partial.render!(context)
        }.strip

        content = parse_convertible(content, context)

        unless content.nil? || filters.nil?
          content = Helpers::Var.render_filters(content, filters, context)
        end

        content
      end

      def read(markup, context)
        path = markup.match(SYNTAX)[1]
        @path = Helpers::Path.expand(path, context)
        begin
          Pathname.new(@path).read
        rescue
          raise IOError.new "Render failed: {% #{@tag_name} #{@og_markup}%}. The file '#{path}' could not be found at #{@path}."
        end
      end
      
      def parse_convertible(content, context)
        page = Jekyll::ConvertiblePage.new(context.registers[:site], @path, content)
        page.render({})
        page.output.strip
      end
      
    end
  end
end

