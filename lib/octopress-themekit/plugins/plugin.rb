
module ThemeKit
  class Plugin
    class << self
      attr_accessor :assets_path
      attr_accessor :stylesheets
      attr_accessor :stylesheets_dir
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
      @stylesheets = Asset.new(@assets_path, @name, 'stylesheets')
      @javascripts = Asset.new(@assets_path, @name, 'javascripts')
      add_assets
    end

    def add_layouts
      @layouts = Asset.new(@assets_path, @name, 'layouts')
    end

    def add_stylesheet(file, media=nil)
      @stylesheets.add Stylesheet.new(file, media)
    end

    def add_stylesheets(files, media=nil)
      files.each { |file| @stylesheets.add Stylesheet.new(file, media) }
    end

    def add_javascript(file)
      @javascripts.add Javascript.new(file)
    end

    def add_javascripts(files)
      files.each { |file| @javascripts.add Javascript.new(file) }
    end

    def stylesheets(site)
      @stylesheets.files(site)
    end

    def javascripts(site)
      @javascripts.files(site)
    end

    def stylesheet_tags(site)
      @stylesheets.tags(site)
    end

    def javascript_tags(site)
      @javascripts.tags(site)
    end

    def layout(file, site)
      @layouts.file(file, site)
    end
  end
end
