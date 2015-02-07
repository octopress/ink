module Octopress
  module Ink
    class Page < Jekyll::Page
      include Ink::Convertible
      attr_reader :asset, :plugin

      # Purpose: Configs can override a page's permalink
      #
      # url - Path relative to destination directory.
      #       examples: 
      #         - '/' for the _site/index.html page
      #         - '/archive/' for the _site/archive/index.html page
      #
      def initialize(site, base, dir, name, asset)
        @asset = asset
        @plugin = asset.plugin
        super(site, base, dir, name)
      end

      def destination(dest)
        unless @dest
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
        @url ||= begin
          @asset.permalink ||= self.data['permalink']
          url = @asset.permalink

          super

          if url && url =~ /\/$/
            if self.ext == '.xml'
              url = File.join(url, "index.xml")
            else
              url = File.join(url, "index.html")
            end
          end

          url
        end
      end
    end
  end
end
