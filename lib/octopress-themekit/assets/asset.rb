module ThemeKit
  class Asset

    def initialize(plugin, type, file)
      @file = file
      @root = plugin.assets_path
      @dir = File.join(plugin.name, type)
      @exists = {}
    end

    def path(site)
      @path ||= Pathname.new(file_path(site))
      @path
    end

    def file_path(site)
      if exists? file = user_path(site)
        file
      elsif exists? file = plugin_path
        file
      else
        raise IOError.new "Could not find #{File.basename(file)} at #{file}"
      end
    end

    def plugin_path
      File.join @root, @dir, @file
    end

    def user_path(site)
      File.join site.source, Plugins.theme_dir(site), @dir, @file
    end

    def exists?(file)
      @exists[file] ||= File.exists?(file)
      @exists[file]
    end
  end
end
