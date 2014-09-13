module Octopress
  module Docs
    class Doc
      attr_reader :filename

      def initialize(options={})
        @file            = options[:file]
        @base_dir        = options[:base_dir] ||= '.'
        @dir             = File.dirname(@file)
        @plugin_name     = options[:plugin_name]
        @plugin_slug   ||= options[:plugin_slug] || @plugin_name
        @plugin_type     = options[:plugin_type] || 'plugin'
        @base_path       = options[:base_path]
      end

      # Add doc page to Jekyll pages
      #
      def add
        if Octopress.config['docs_mode']
          Octopress.site.pages << page
        end
      end

      def disabled?
        false
      end

      def file
        File.basename(@file)
      end

      def info
        "  - #{permalink.ljust(35)}"
      end

      def page
        return @page if @page
        @page = Octopress::Ink::Page.new(Octopress.site, @base_dir, page_dir, file, {'path'=>base_path})
        @page.data['layout'] = 'docs'
        @page.data['plugin'] = { 
          'name' => @plugin_name, 
          'slug' => plugin_slug,
          'docs_base_path' => base_path
        }
        @page.data['dir'] = doc_dir
        @page
      end

      private

      def permalink
        File.basename(file, ".*")
      end

      def read
        File.open(File.join(@base_dir, @file)).read
      end

      def plugin_slug
        Filters.sluggify @plugin_type == 'theme' ? 'theme' : @plugin_slug
      end

      def base_path
        @base_path || if @plugin_type == 'theme'
          File.join('docs', 'theme')
        else
          File.join('docs', 'plugins', @plugin_slug)
        end
      end

      def page_dir
        @dir == '.' ? '' : @dir
      end

      def doc_dir
        File.join(@base_dir, page_dir, File.dirname(file))
      end

    end
  end
end
