module Octopress
  module Ink
    class Page < Jekyll::Page
      include Ink::Convertible
      attr_accessor :dir, :name, :plugin, :asset

      def relative_asset_path
        site_source = Pathname.new Octopress.site.source
        page_source = Pathname.new @base
        page_source.relative_path_from(site_source).to_s
      end

      def render(layouts, site_payload)
        site_payload = {
          'plugin' => plugin.config(data['lang'])
        }.merge(site_payload)

        super(layouts, site_payload)
      end
      

      # Allow pages to read url from plugin configuration
      #
      def url
        @url ||= begin
          super

          if @url && @url =~ /\/$/
            if self.ext == '.xml'
              @url = File.join(url, "index.xml")
            else
              @url = File.join(url, "index.html")
            end
          end

          @url
        end
      end
    end
  end
end
