module ThemeKit
  class Asset
    attr_accessor :assets

    def initialize(assets_path, dir)
      @assets_path = assets_path
      @dir = dir
      @files = []
      @exists = {}
    end

    def theme_dir(site)
      site.config['theme'] || THEME_DIR
    end

    def add(file)
      @files << file
    end

    def files(site)
      @files.each do |file|
        path = file.respond_to?(:path) ? file.path : file
        add_static_file(file.path, site)
      end
    end

    def file(file, site)
      file_path(file, site)
    end

    def add_static_file(path, site)
      if exists? user_path(path, site)
        site.static_files << Jekyll::StaticFile.new(site, site.source, File.join(theme_dir(site), @dir), path)
      elsif exists? theme_path(path, site)
        site.static_files << Jekyll::StaticFile.new(site, @assets_path, File.join(theme_dir(site), @dir), path)
      else
        raise IOError.new "Could not find #{File.basename(path)}"
      end
    end

    def theme_path(file, site)
      File.join @assets_path, theme_dir(site), @dir, file
    end

    def user_path(file, site)
      source_path = site.source
      File.join source_path, theme_dir(site), @dir, file
    end

    def tags(site)
      paths = []
      @files.each do |file|
        if file_path(file.path, site)
          paths << file.tag(File.join(theme_dir(site), @dir))
        end
      end
      paths
    end

    def file_path(file, site)
      path = user_path(file, site)
      path = theme_path(file, site) unless exists?(path)

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
