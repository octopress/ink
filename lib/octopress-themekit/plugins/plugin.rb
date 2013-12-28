
module ThemeKit
  class Plugin
    class << self
      attr_accessor :assets_path
      attr_accessor :stylesheets
    end

    def initialize(name)
      @name = name
      @images_dir      = 'images'
      @fonts_dir       = 'fonts'
      @layouts_dir     = 'layouts'
      @embeds_dir      = 'embeds'
      @files_dir       = 'files'
      @images      = []
      @fonts       = []
      @layouts     = []
      @embeds      = []
      @files       = []
      @stylesheets = Asset.new(@assets_path, @name, Plugins::STYLESHEETS_DIR)
      @javascripts = Asset.new(@assets_path, @name, Plugins::JAVASCRIPTS_DIR)
      add_assets
    end

    def add_layouts
      @layouts = Asset.new(@assets_path, @name, Plugins::LAYOUTS_DIR)
    end

    def name
      @name
    end

    def add_stylesheet(file, media=nil)
      @stylesheets.add Stylesheet.new(file, media)
    end

    def add_stylesheets(files, media=nil)
      files.each { |file| add_stylesheet(file, media) }
    end

    def add_javascript(file)
      @javascripts.add Javascript.new(file)
    end

    def add_javascripts(files)
      files.each { |file| add_javascript(file) }
    end

    def javascript_paths(site)
      @javascripts.file_paths(site)
    end

    def stylesheet_paths(site)
      @stylesheets.file_paths(site)
    end

    def stylesheet_tags
      @stylesheets.tags
    end

    def javascript_tags
      @javascripts.tags
    end

    def layout(file, site)
      @layouts.file(file, site)
    end
  end
end
