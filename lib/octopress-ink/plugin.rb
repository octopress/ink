require 'find'

module Octopress
  module Ink
    class Plugin
      attr_accessor :name, :type, :asset_override, :assets_path,
                    :layouts_dir, :stylesheets_dir, :javascripts_dir, :files_dir, :includes_dir, :images_dir,
                    :layouts, :includes, :stylesheets, :javascripts, :images, :sass, :fonts, :files, :pages,
                    :website, :description, :version

      def initialize(name, type)
        @layouts_dir       = 'layouts'
        @files_dir         = 'files'
        @pages_dir         = 'pages'
        @fonts_dir         = 'fonts'
        @images_dir        = 'images'
        @includes_dir      = 'includes'
        @javascripts_dir   = 'javascripts'
        @stylesheets_dir   = 'stylesheets'
        @plugins_dir       = 'plugins'
        @config_file       = 'config.yml'
        @name              = name
        @type              = type
        @layouts           = []
        @includes          = {}
        @stylesheets       = []
        @javascripts       = []
        @images            = []
        @sass              = []
        @fonts             = []
        @files             = []
        @pages             = []
        @version         ||= false
        @description     ||= false
        @website         ||= false
        add_assets
        add_layouts
        add_pages
        add_includes
        add_config
        require_plugins
      end

      def add_assets; end

      def add_config
        @config_file = Assets::Config.new(self, @config_file)
      end

      def slug
        if @type == 'local_plugin'
          ''
        else
          @type == 'theme' ? @type : @name
        end
      end

      def assets
        {
          'layouts'     => @layouts,
          'includes'    => @includes.values,
          'pages'       => @pages, 
          'sass'        => @sass, 
          'stylesheets' => @stylesheets,
          'javascripts' => @javascripts, 
          'images'      => @images, 
          'fonts'       => @fonts, 
          'files'       => @files
        }
      end

      def info(options={})
        message =  @name
        message += " (theme)" if @type == 'theme'
        message += " - v#{@version}" if @version
        message += " - #{@description}" if @description
        message += "\n"
        if options == {}
          asset_types = assets
        else
          asset_types = assets.select{|k,v| options.keys.include?(k)}
        end
        asset_types.each do |name, assets|
          if assets.size > 0
            message += "#{name.capitalize}:\n"
            assets.each do |t|
              message += "  - #{t.info}\n"
            end
          elsif options != {}
            message += "#{name.capitalize}: none\n"
          end
        end
        message
      end

      def add_stylesheet(file, media=nil)
        @stylesheets << Assets::Stylesheet.new(self, @stylesheets_dir, file, media)
      end

      def add_sass(file, media=nil)
        @sass << Assets::Sass.new(self, @stylesheets_dir, file, media)
      end

      def add_javascript(file)
        @javascripts << Assets::Javascript.new(self, @javascripts_dir, file)
      end

      def add_pages
        if @assets_path
          find_assets(File.join(@assets_path, @pages_dir)).each do |file|
            @pages << Assets::PageAsset.new(self, @pages_dir, file)
          end
        end
      end

      def require_plugins
        if @assets_path
          find_assets(File.join(@assets_path, @plugins_dir)).each do |file|
            require File.join base, file
          end
        end
      end

      def find_assets(dir)
        found = []
        if Dir.exist? dir
          Find.find(dir) do |file|
            found << file.sub(dir+'/', '') unless File.directory? file
          end
        end
        found
      end

      def add_layouts
        if @assets_path
          find_assets(File.join(@assets_path, @layouts_dir)).each do |layout|
            @layouts << Assets::Layout.new(self, @layouts_dir, layout)
          end
        end
      end

      def remove_jekyll_assets(files)
        files.each {|f| f.remove_jekyll_asset }
      end

      def add_includes
        if @assets_path
          find_assets(File.join(@assets_path, @includes_dir)).each do |include_file|
            @includes[include_file] = Assets::Asset.new(self, @includes_dir, include_file)
          end
        end
      end

      def add_image(file)
        @images << Assets::Asset.new(self, @images_dir, file)
      end

      def add_root_files(files)
        files.each { |f| add_root_file(f) }
      end

      def add_root_file(file)
        @files << Assets::RootAsset.new(self, @files_dir, file)
      end

      def add_font(file)
        @fonts << Assets::Asset.new(self, @fonts_dir, file)
      end

      def add_file(file)
        @files << Assets::Asset.new(self, @files_dir, file)
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

      def stylesheet_paths
        get_paths @stylesheets
      end

      def javascript_paths
        get_paths @javascripts
      end

      def stylesheet_tags
        get_tags @stylesheets
      end

      def sass_tags
        get_tags @sass
      end

      def javascript_tags
        get_tags @javascripts
      end

      def get_paths(files)
        files.dup.map { |f| f.path }
      end

      def get_tags(files)
        files.dup.map { |f| f.tag }
      end

      def include(file)
        @includes[file].path
      end

      def config
        @config ||= @config_file.read
      end
    end
  end
end
