module ThemeKit
  class Layout < Asset

    def initialize(plugin, type)
      @root = plugin.assets_path
      @dir = File.join(plugin.name, type)
      @exists = {}
    end

    def file(file, site)
      @file = file
      Pathname.new(file_path(site))
    end

    def tag(base_url)
      "<script src='/#{File.join(@dir, @file)}'></script>"
    end
  end
end
