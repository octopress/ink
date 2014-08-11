module Octopress
  module Ink
    class Page < Jekyll::Page
      include Jekyll::Convertible

      # Purpose: Configs can override a page's permalink
      #
      # url - Path relative to destination directory.
      #       examples: 
      #         - '/' for the _site/index.html page
      #         - '/archive/' for the _site/archive/index.html page
      #
      def initialize(site, base, dir, name, config={})
        @config = config
        super(site, base, dir, name)
        post_init if respond_to?(:post_init)
      end

      def hooks
        self.site.page_hooks
      end

      def destination(dest)
        unless @dest
          if @config['path']
            dest = File.join(dest, @config['path'])
          end
          @dest = File.join(dest, self.url)
        end
        @dest
      end

      def relative_asset_path
        site_source = Pathname.new Octopress.site.source
        page_source = Pathname.new @base
        page_source.relative_path_from(site_source).to_s
      end

      # Allow pages to read url from plugin configuration
      #
      def url
        if @url
          @url
        else
          begin

            page_name = File.basename(self.name, '.*')
            config = @config['permalinks'][page_name]

            if config.is_a? String
              @url = config
              self.data['permalink'] = nil
            else
              @config['permalinks'][File.basename(self.name, '.*')] = self.data['permalink']
            end
          rescue; end

          super

          if @url && @url =~ /\/$/
            if self.ext == '.xml'
              @url = File.join(@url, "index.xml")
            else
              @url = File.join(@url, "index.html")
            end
          end

          @url
        end
      end
    end
  end
end
