module Octopress
  module Ink
    module Assets
      class Template < Asset
        attr_reader :pages

        def initialize(*args)
          super(*args)
          @pages = []
        end

        def add; end

        def info
          message = filename.ljust(35)

          if disabled?
            message += "-disabled-"
          elsif path.to_s != plugin_path
            shortpath = File.join(Plugins.custom_dir.sub(Dir.pwd,''), dir).sub('/','')
            message += "from: #{shortpath}/#{filename}"
          end

          message = "  - #{message}\n"

          self.pages.each do |page|
            message << "     /#{page.path.sub('index.html', '')}\n"
          end
          message
        end

        def new_page(data={})
          return if disabled?
          page = Ink::Page.new(Octopress.site, File.dirname(self.path), '.', File.basename(self.path))
          page.data.merge!(data)

          self.pages << page

          page
        end
      end
    end
  end
end
