
module ThemeKit
  class Theme
    THEME_DIR = "_theme"
    class << self
      attr_accessor :assets_path
      attr_accessor :stylesheets
      attr_accessor :stylesheets_dir
    end

    def initialize
      @stylesheets_dir = 'stylesheets'
      @javascripts_dir = 'javascripts'
      @images_dir      = 'images'
      @fonts_dir       = 'fonts'
      @layouts_dir     = 'layouts'
      @embeds_dir      = 'embeds'
      @files_dir       = 'files'
      @stylesheets = []
      @javascripts = []
      @images      = []
      @fonts       = []
      @layouts     = []
      @embeds      = []
      @files       = []
      add_assets
    end

    def add_assets_path(dir)
      @assets_path = dir
    end

    def stylesheets
      @stylesheets
    end

    def add_stylesheet(file, media=nil)
      @stylesheets << Stylesheet.new(file, media)
    end

    def add_javascript(file)
      @javascripts << file
    end

    def output_stylesheets(site)
      @stylesheets.each do |stylesheet|
        add_static_file(stylesheet.path, @stylesheets_dir, site)
      end
    end

    def output_javascripts(site)
      @javascripts.each do |js|
        add_static_file(js, @javascripts_dir, site)
      end
    end

    def stylesheet_tag(site)
      paths = []
      @stylesheets.each do |css|
        if file_path(css.path, @stylesheets_dir, site)
          paths << css.link(File.join(THEME_DIR, @stylesheets_dir))
        end
      end
      paths
    end

    def javascript_tag(site)
      paths = []
      @javascripts.each do |js|
        if file_path(js, @javascripts_dir, site)
          path = File.join(THEME_DIR, @javascripts_dir, js)
          paths << "<script src='/#{path}'></script>"
        end
      end
      paths
    end

    def add_static_file(path, subdir, site)
      if File.exists? user_path(path, subdir, site)
        site.static_files << Jekyll::StaticFile.new(site, site.source, File.join(THEME_DIR, subdir), path)
      elsif File.exists? theme_path(path, subdir)
        site.static_files << Jekyll::StaticFile.new(site, @assets_path, File.join(THEME_DIR, subdir), path)
      else
        raise IOError.new "Could not find #{File.basename(path)}"
      end
    end

    def stylesheet_links(site)
      paths = []
      @stylesheets.each do |stylesheet|
        paths << file_path(stylesheet.path, @stylesheets_dir, site)
      end
    end

    def layout(file, site)
      file_path(file, @layouts_dir, site)
    end

    def file_path(file, subdir, site)
      path = exists(user_path(file, subdir, site)) || exists(theme_path(file, subdir))

      unless path
        raise IOError.new "Could not find #{File.basename(path)} at #{path}"
      end

      Pathname.new(path)
    end

    def exists(path)
      File.exists?(path) ? path : false
    end

    def theme_path(file, subdir)
      File.join @assets_path, THEME_DIR, subdir, file
    end

    def user_path(file, subdir, site)
      File.join user_theme_path(site), subdir, file
    end

    def user_theme_path(site)
      source_path = site.source
      theme_dir = site.config['theme'] || THEME_DIR
      File.join(source_path, theme_dir)
    end
  end
end
