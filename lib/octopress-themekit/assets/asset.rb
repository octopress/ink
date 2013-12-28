module ThemeKit
  class Asset
    attr_accessor :assets

    def initialize(assets_path, name, asset_type)
      @assets_path = assets_path
      @name = name
      @dir = File.join(@name, asset_type)
      @files = []
      @exists = {}
    end

    def add(file)
      @files << file
    end

    def file_paths(site)
      files = []
      @files.each do |file|
        path = file.respond_to?(:path) ? file.path : file
        files << file_path(path, site)
      end
      files
    end

    def file(file, site)
      file_path(file, site)
    end

    def plugin_path(file, site)
      File.join @assets_path, @dir, file
    end

    def user_path(file, site)
      source_path = site.source
      File.join source_path, Plugins.theme_dir(site), @dir, file
    end

    def tags
      paths = []
      @files.each do |file|
        paths << file.tag(@dir)
      end
      paths
    end

    def file_path(file, site)
      path = user_path(file, site)
      path = plugin_path(file, site) unless exists?(path)

      unless exists?(path)
        raise IOError.new "Could not find #{File.basename(path)} at #{path}"
      end

      Pathname.new(path)
    end

    def exists?(path)
      @exists[path] ||= File.exists?(path)
      @exists[path]
    end
  end
end
