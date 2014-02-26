require 'find'

module Octopress
  module Ink
    class Plugin
      attr_accessor :name, :type, :asset_override, :assets_path,
                    :layouts_dir, :stylesheets_dir, :javascripts_dir, :files_dir, :includes_dir, :images_dir,
                    :layouts, :includes, :images, :fonts, :files, :pages,
                    :website, :description, :version, :config

      def initialize(name, type)
        @layouts_dir       = 'layouts'
        @files_dir         = 'files'
        @pages_dir         = 'pages'
        @fonts_dir         = 'fonts'
        @images_dir        = 'images'
        @includes_dir      = 'includes'
        @javascripts_dir   = 'javascripts'
        @stylesheets_dir   = 'stylesheets'
        @sass_dir          = 'stylesheets'
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
      end

      def register
        add_config
        disable_assets
        add_assets
        add_layouts
        add_pages
        add_includes
        require_plugins
      end

      def add_assets; end

      def add_config
        @config = Assets::Config.new(self, @config_file).read
      end

      def disable_assets
        disabled = []
        @config['disable'] ||= {}
        @config['disable'].each do |key,val| 
          next unless can_disable.include? key
          if !!val == val
            disabled << key if val
          elsif val.is_a? Array
            val.each { |v| disabled << File.join(key, v) }
          elsif val.is_a? String
            disabled << File.join(key, val)
          end
        end
        @config['disable'] = disabled
      end

      def disabled?(dir, file)
        @config['disable'].include?(dir) || @config['disable'].include?(File.join(dir, file))
      end

      def slug
        if @type == 'local_plugin'
          ''
        else
          @type == 'theme' ? @type : @name
        end
      end

      def can_disable
        [ 
          'pages',
          'sass',
          'stylesheets',
          'javascripts',
          'images',
          'fonts',
          'files'
        ]
      end

      def assets
        {
          'layouts'     => @layouts,
          'includes'    => @includes.values,
          'pages'       => @pages, 
          'sass'        => @sass, 
          'stylesheets' => @stylesheets,
          'css'         => @stylesheets,  #less typing ftw
          'javascripts' => @javascripts, 
          'js'          => @javascripts,  #less typing ftw
          'images'      => @images, 
          'fonts'       => @fonts, 
          'files'       => @files
        }
      end

      def info(options={})
        if options == 'brief'
          message = " #{@name}"
          message += " (theme)" if @type == 'theme'
          message += " - v#{@version}" if @version
          if @description
            message = "#{message.ljust(30)} #{@description}"
          end
          message += "\n"
        else
          asset_info = assets_info(options)
          return '' if asset_info.empty?

          name = "Plugin: #{@name}"
          name += " (theme)" if @type == 'theme'
          name += " - v#{@version}" if @version
          name  = pad_line(name)
          message = name

          if @description
            message += "\n#{pad_line(@description)}"
          end

          lines = ''
          80.times { lines += '=' }

          message = "#{lines}\n#{message}\n#{lines}\n"
          message += asset_info
          message += "\n"
        end
      end

      def pad_line(line)
        line = "| #{line.ljust(76)} |"
      end

      # Return information about each asset 
      def assets_info(options)
        message = ''
        no_assets = []

        select_assets(options).each do |name, assets|
          next if assets.size == 0
          message += " #{name.capitalize}:\n"
          assets.each do |asset|
            message += "  - #{asset.info}\n"
          end
          message += "\n"
        end

        message
      end

      # Return selected assets
      #
      # input: options (an array ['type',...], hash {'type'=>true}
      # or string of asset types)
      # 
      # Output a hash of assets instances {'files' => @files }
      #
      def select_assets(options)
        # Accept options from the CLI (as a hash of asset: true)
        # Or from Ink modules as an array of asset names
        #
        if options.is_a? Hash
          options = options.keys
        end
        options = [options] if options.is_a? String
        
        # Remove options which don't belong
        #
        options.select!{|o| assets.include?(o)}

        if options.nil? || options.empty?
          assets
        else
          assets.select{|k,v| options.include?(k)}
        end
      end

      def add_stylesheet(file, media=nil)
        @stylesheets << Assets::Stylesheet.new(self, @stylesheets_dir, file, media)
      end

      def add_sass(file, media=nil)
        @sass << Assets::Sass.new(self, @sass_dir, file, media)
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

      def add_layouts
        if @assets_path
          find_assets(File.join(@assets_path, @layouts_dir)).each do |layout|
            layout = Assets::Layout.new(self, @layouts_dir, layout)
            @layouts << layout
            layout.register
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

      def add_asset_files(options)
        options = [options] unless options.is_a? Array 
        select_assets(options).each do |name, assets|
          assets.each {|file| file.add unless file.disabled? }
        end
      end

      def copy_asset_files(path, options)
        select_assets(options).each do |name, assets|
          assets.each { |a| puts a.copy(path) }
        end
        ''
      end

      def add_image(file)
        @images << Assets::Asset.new(self, @images_dir, file)
      end

      def add_file(file)
        @files << Assets::FileAsset.new(self, @files_dir, file)
      end

      def add_font(file)
        @fonts << Assets::Asset.new(self, @fonts_dir, file)
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
        get_paths @stylesheets.reject{|f| f.disabled? }
      end

      def javascript_paths
        get_paths @javascripts.reject{|f| f.disabled? }
      end

      def stylesheet_tags
        get_tags @stylesheets.reject{|f| f.disabled? }
      end

      def stylesheets
        @stylesheets.reject{|f| f.disabled? }
      end

      def sass
        @sass.reject{|f| f.disabled? }
      end

      def javascripts
        @javascripts.reject{|f| f.disabled? }
      end

      def sass_tags
        get_tags @sass
      end

      def javascript_tags
        get_tags @javascripts
      end

      def get_paths(files)
        files.dup.map { |f| f.path }.compact
      end

      def get_tags(files)
        files.dup.map { |f| f.tag }
      end

      def include(file)
        @includes[file].path
      end
    end
  end
end
