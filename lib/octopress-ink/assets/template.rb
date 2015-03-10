module Octopress
  module Ink
    module Assets
      class Template < Asset
        attr_reader :pages

        def initialize(*args)
          super(*args)
          @pages = []
          @existing_pages = {}
        end

        def add; end

        def info
          message = "  - #{asset_info}\n"

          unless disabled?
            self.pages.each do |page|
              if existing_page = @existing_pages[page.url]
                message << "     #{page.url.ljust(33)} Disabled: /#{existing_page.path} already exists\n"
              else
                message << "     #{page.url}\n"
              end
            end
          end

          message
        end

        def new_page(data={})
          return if disabled?
          page = Ink::Page.new(Octopress.site, File.dirname(self.path), '.', File.basename(self.path))
          page.data.merge!(data)
          page.plugin = plugin
          page.asset = self
          self.pages << page

          if existing_page = page_exists?(page)
            if existing_page.respond_to?(:plugin)
              @replacement = existing_page.plugin.name
            else
              @existing_pages[existing_page.url] = existing_page
            end
            false
          else
            page
          end
        end

        def page_exists?(page)
          Octopress.site.pages.find {|p| p.url == page.url}
        end
      end
    end
  end
end
