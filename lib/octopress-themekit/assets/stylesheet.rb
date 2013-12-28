module ThemeKit
  class Stylesheet < Asset
    def initialize(plugin, type, file, media)
      @file = file
      @root = plugin.assets_path
      @dir = File.join(plugin.name, type)
      @media = media || 'all'
      @exists = {}
    end

    def media
      @media
    end

    def tag
      "<link href='/#{File.join(@dir, @file)}' media='#{@media}' rel='stylesheet' type='text/css'>"
    end
  end
end
