
module ThemeKit
  class Theme
    class << self
      attr_accessor :assets_path
      attr_accessor :stylesheets
      attr_accessor :stylesheets_dir
    end

    def initialize
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
      add_assets
    end

    def add_layouts
      @layouts = Asset.new(@assets_path, 'layouts')
    end

    def add_stylesheet(file, media=nil)
      @stylesheets ||= Asset.new(@assets_path, 'stylesheets')
      @stylesheets.add Stylesheet.new(file, media)
    end

    def add_javascript(file)
      @javascripts ||= Asset.new(@assets_path, 'javascripts')
      @javascripts.add Javascript.new(file)
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
