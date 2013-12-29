
module ThemeKit
  class Plugin

    LAYOUTS_DIR     = 'layouts'
    FILES_DIR       = 'files'
    FONTS_DIR       = 'fonts'
    IMAGES_DIR      = 'images'
    EMBEDS_DIR      = 'embeds'
    JAVASCRIPTS_DIR = 'javascripts'
    STYLESHEETS_DIR = 'stylesheets'

    def initialize(name, type)
      @name        = name
      @type        = type
      @layouts     = []
      @embeds      = []
      @stylesheets = []
      @javascripts = []
      @images      = []
      @sass        = []
      @fonts       = []
      @files       = []
      add_assets
      add_layouts
      add_embeds
    end

    def name_space
      @type == 'theme' ? @type : @name
    end

    def name
      @name
    end

    def type
      @type
    end

    def assets_path
      @assets_path
    end

    def add_stylesheet(file, media=nil)
      @stylesheets << Stylesheet.new(self, STYLESHEETS_DIR, file, media)
    end

    def add_sass(file, media=nil)
      begin
        require 'sass'
      rescue LoadError
        raise IOError.new "The #{@name} #{@type} uses the Sass gem. You'll need to add it to your Gemfile or run `gem install sass`"
      end
      @sass << Sass.new(self, STYLESHEETS_DIR, file, media)
    end

    def add_javascript(file)
      @javascripts << Javascript.new(self, JAVASCRIPTS_DIR, file)
    end

    def add_layouts
      @layouts = Template.new(self, LAYOUTS_DIR)
    end

    def add_embeds
      @embeds = Template.new(self, EMBEDS_DIR)
    end

    def add_image(file)
      @images << Asset.new(self, IMAGES_DIR, file)
    end

    def add_font(file)
      @images << Asset.new(self, FONTS_DIR, file)
    end

    def add_file(file)
      @images << Asset.new(self, FILES_DIR, file)
    end

    def add_stylesheets(files, media=nil)
      files.each { |f| add_stylesheet(f, media) }
    end

    def add_sass_files(files, media=nil)
      files.each { |f| add_sass(f, media) }
    end

    def add_javascripts(files)
      files.each { |f| add_javascript(f) }
    end

    def add_images(files)
      files.each { |f| add_image(f) }
    end

    def add_fonts(files)
      files.each { |f| add_font(f) }
    end

    def add_files(files)
      files.each { |f| add_file(f) }
    end

    def stylesheet_paths(site)
      get_paths(@stylesheets, site)
    end

    def stylesheets
      @stylesheets
    end

    def sass
      @sass
    end

    def javascripts
      @javascripts
    end

    def images
      @images
    end

    def fonts
      @fonts
    end

    def files
      @files
    end

    def javascript_paths(site)
      get_paths(@javascripts, site)
    end

    def stylesheet_tags
      get_tags(@stylesheets)
    end

    def sass_tags
      get_tags(@sass)
    end

    def javascript_tags
      get_tags(@javascripts)
    end

    def get_paths(files, site)
      files.dup.map { |f| f.path(site) }
    end

    def get_tags(files)
      files.dup.map { |f| f.tag }
    end

    def embed(file, site)
      @embeds.file(file, site)
    end

    def layout(file, site)
      @layouts.file(file, site)
    end
  end
end
