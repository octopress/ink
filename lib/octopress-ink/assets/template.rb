module Octopress
  module Ink
    module Assets
      class Template < Asset
        attr_accessor :pages

        def add; end

        def info
          message = filename.ljust(35)
          if disabled?
            message += "-disabled-"
          elsif path.to_s != plugin_path
            shortpath = File.join(Plugins.custom_dir.sub(Dir.pwd,''), dir).sub('/','')
            message += "from: #{shortpath}/#{filename}"
          end
          message = "  #{message}\n"
          self.pages.each do |page|
            message << "   - #{page.path.sub('index.html', '')}\n"
          end
          message
        end

        def new_page(permalink, data={})
          @pages ||= []
          return if disabled?

          dir = File.dirname(permalink)
          name = File.basename(permalink)

          page = Ink::TemplatePage.new(Octopress.site, File.dirname(self.path), '.', File.basename(self.path))

          page.data.merge!(data)

          page.dir = dir
          page.name = name
          page.process(name)

          page
        end

      end
    end
  end
end
