module ThemeKit
  class Sass < Asset
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

    def user_load_path(site)
      File.join site.source, Plugins.theme_dir(site), @dir, File.dirname(@file)
    end

    def theme_load_path
      File.expand_path(File.join(@root, @dir))
    end
    
    def compile(site)
      unless @compiled
        ENV['SASS_PATH'] = user_load_path(site) + ':' + theme_load_path
        @compiled = ::Sass.compile_file(file_path(site))
      end
      @compiled
    end

    def copy(site)
      site.static_files << ThemeKit::StaticFileContent.new(compile(site), destination)
    end
  end
end
