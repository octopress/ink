module Octopress
  module Ink
    class Page < Jekyll::Page

      # Override the destination for a page
      #
      # url - Path relative to destination directory.
      #       examples: 
      #         - '/' for the _site/index.html page
      #         - '/archive/' for the _site/archive/index.html page
      #
      def initialize(site, base, dir, name, config={})
        @config = config
        super(site, base, dir, name)
      end

      def destination(dest)
        if @config['path']
          dest = File.join(dest, @config['path'])
        end
        File.join(dest, self.url)
      end

      # Allow pages to read url from plugin configuration
      #
      def url
        if @url
          @url
        else
          begin
            config = @config['permalinks'][File.basename(self.name, '.*')]
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
