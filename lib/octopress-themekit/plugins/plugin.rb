
module ThemeKit
  class Plugin
    attr_accessor :name, :type, :asset_override, :assets_path,
                  :layouts_dir, :stylesheets_dir, :javascripts_dir, :files_dir, :embeds_dir, :images_dir,
                  :layouts, :embeds, :stylesheets, :javascripts, :images, :sass, :fonts, :files

    def initialize(name, type)
      @layouts_dir       = 'layouts'
      @files_dir         = 'files'
      @fonts_dir         = 'fonts'
      @images_dir        = 'images'
      @embeds_dir        = 'embeds'
      @javascripts_dir   = 'javascripts'
      @stylesheets_dir   = 'stylesheets'
      @name              = name
      @type              = type
      @layouts           = []
      @embeds            = []
      @stylesheets       = []
      @javascripts       = []
      @images            = []
      @sass              = []
      @fonts             = []
      @files             = []
      add_assets
      add_layouts
      add_embeds
    end

    def namespace
      if @type == 'local_plugin'
        ''
      else
        @type == 'theme' ? @type : @name
      end
    end

    def add_stylesheet(file, media=nil)
      @stylesheets << Stylesheet.new(self, @stylesheets_dir, file, media)
    end

    def add_sass(file, media=nil)
      begin
        require 'sass'
      rescue LoadError
        raise IOError.new "The #{@name} #{@type} uses the Sass gem. You'll need to add it to your Gemfile or run `gem install sass`"
      end
      @sass << Sass.new(self, @stylesheets_dir, file, media)
    end

    def add_javascript(file)
      @javascripts << Javascript.new(self, @javascripts_dir, file)
    end

    def add_layouts
      @layouts = Template.new(self, @layouts_dir)
    end

    def add_embeds
      @embeds = Template.new(self, @embeds_dir)
    end

    def add_image(file)
      @images << Asset.new(self, @images_dir, file)
    end

    def add_font(file)
      @images << Asset.new(self, @fonts_dir, file)
    end

    def add_file(file)
      @images << Asset.new(self, @files_dir, file)
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
