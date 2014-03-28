require 'find'

module Octopress
  module Ink
    class Plugin

      DEFAULT_CONFIG = {
        type: 'plugin'
      }

      attr_reader   :name, :type, :assets_path, :local, :website, :description, :version,
                    :layouts_dir, :stylesheets_dir, :javascripts_dir, :files_dir, :includes_dir, :images_dir,
                    :layouts, :includes, :images, :fonts, :files, :pages, :docs

      def initialize(options={})
        DEFAULT_CONFIG.merge(options || configuration).each { |k,v| set_config(k,v) }

        @layouts_dir       = 'layouts'
        @files_dir         = 'files'
        @pages_dir         = 'pages'
        @docs_dir          = 'docs'
        @fonts_dir         = 'fonts'
        @images_dir        = 'images'
        @includes_dir      = 'includes'
        @javascripts_dir   = 'javascripts'
        @stylesheets_dir   = 'stylesheets'
        @config_file       = 'config.yml'
        @layouts           = []
        @includes          = []
        @css               = []
        @javascripts       = []
        @images            = []
        @sass              = []
        @docs              = []
        @fonts             = []
        @files             = []
        @pages             = []
        @slug            ||= @name
      end

      def configuration; {}; end

      def set_config(name,value)
        instance_variable_set("@#{name}", value)
        instance_eval(<<-EOS, __FILE__, __LINE__ + 1)
          def #{name}
            @#{name}
          end
        EOS
      end

      def register
        unless @assets_path.nil?
          disable_assets
          add_assets
          add_layouts
          add_includes
          add_javascripts
          add_fonts
          add_images
          add_docs
          add_files
          add_pages
          add_stylesheets
        end
      end

      def add_assets; end

      def stylesheets
        css.clone.concat sass_without_partials
      end

      def config
        @config ||= Assets::Config.new(self, @config_file).read
      end

      def disable_assets
        disabled = []
        config['disable'] ||= {}
        config['disable'].each do |key,val| 
          next unless can_disable.include? key
          if !!val == val
            disabled << key if val
          elsif val.is_a? Array
            val.each { |v| disabled << File.join(key, v) }
          elsif val.is_a? String
            disabled << File.join(key, val)
          end
        end
        config['disable'] = disabled
      end

      def disabled?(dir, file)
        config['disable'].include?(dir) || config['disable'].include?(File.join(dir, file))
      end

      def slug
        Filters.sluggify @type == 'theme' ? @type : @slug
      end

      def docs_base_path
        type = @type == 'plugin' ? 'plugins' : @type
        File.join('docs', type, slug)
      end

      # Docs pages for easy listing in an index
      #
      # returns: Array of hashes including doc page title and url
      #
      def doc_pages
        if !@docs.empty?
          @doc_pages ||= @docs.clone.map { |d|
            page = d.page
            title   = page.data['link_title'] || page.data['title'] || page.basename
            url = File.join('/', docs_base_path, page.url.sub('index.html', ''))

            {
              'title' => title,
              'url' => url
            }
          }.sort_by { |i| 
            # Sort by depth of url
            i['url'].split('/').size
          }
        end
      end

      def can_disable
        [ 
          'pages',
          'sass',
          'css',
          'stylesheets',
          'javascripts',
          'images',
          'fonts',
          'files'
        ]
      end

      def assets
        {
          'docs'        => @docs,
          'layouts'     => @layouts,
          'includes'    => @includes,
          'pages'       => @pages, 
          'sass'        => @sass, 
          'css'         => @css,
          'javascripts' => @javascripts, 
          'images'      => @images, 
          'fonts'       => @fonts, 
          'files'       => @files
        }
      end

      def info(options={})
        if options['minimal']
          message = " #{@name}"
          message += " (#{slug})"
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
          name  = name
          message = name
          message += "\nSlug: #{slug}"

          if @description
            message += "\n#{@description}"
          end

          lines = ''
          80.times { lines += '=' }

          message = "\n#{message}\n#{lines}\n"
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

        if options['stylesheets']
          options['css'] = true
          options['sass'] = true
          options.delete('stylesheets')
        end

        select_assets(options).each do |name, assets|
          next if assets.size == 0
          if name == 'docs'
            message += " documentation: /#{docs_base_path}/\n"
            if assets.size > 1
              assets.each do |asset|
                message += "  - #{asset.info}\n"
              end
            end
          else
            message += " #{name}:\n"
            assets.each do |asset|
              message += "  - #{asset.info}\n"
            end
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
      def select_assets(asset_types)
        # Accept options from the CLI (as a hash of asset: true)
        # Or from Ink modules as an array of asset names
        #
        if asset_types.is_a? Hash
          asset_types = asset_types.keys
        end

        asset_types = [asset_types] if asset_types.is_a? String
        
        # Remove options which don't belong
        #
        asset_types.select!{|asset| assets.include?(asset)}

        if asset_types.nil? || asset_types.empty?
          assets
        else
          assets.select{|k,v| asset_types.include?(k)}
        end
      end

      def add_stylesheets
        find_assets(@stylesheets_dir).each do |asset|
          if File.extname(asset) =~ /s[ca]ss/
            @sass << Assets::Sass.new(self, @stylesheets_dir, asset)
          else
            @css << Assets::Stylesheet.new(self, @stylesheets_dir, asset)
          end
        end
      end

      def add_layouts
        @layouts = add_new_assets(@layouts_dir, Assets::Layout)
      end

      def add_includes
        @includes = add_new_assets(@includes_dir, Assets::Asset)
      end

      def add_pages
        @pages = add_new_assets(@pages_dir, Assets::PageAsset)
      end

      def add_docs
        find_assets(@docs_dir).each do |asset|
          unless asset =~ /^_/
            @docs << Assets::DocPageAsset.new(self, @docs_dir, asset)
          end
        end
      end

      def add_files
        @files = add_new_assets(@files_dir, Assets::FileAsset)
      end

      def add_javascripts
        @javascripts = add_new_assets(@javascripts_dir, Assets::Javascript)
      end

      def add_fonts
        @fonts = add_new_assets(@fonts_dir, Assets::Asset)
      end

      def add_images
        @images = add_new_assets(@images_dir, Assets::Asset)
      end

      def add_new_assets(dir, asset_type)
        find_assets(dir).map do |asset|
          asset_type.new(self, dir, asset)
        end
      end

      def find_assets(dir)
        full_dir = File.join(@assets_path, dir)
        glob_assets(full_dir).map do |file|
          file.sub(full_dir+'/', '')
        end
      end

      def glob_assets(dir)
        return [] unless Dir.exist? dir
        Find.find(dir).to_a.reject {|f| File.directory? f }
      end

      #def add_css(file, media=nil)
        #@css << Assets::Stylesheet.new(self, @stylesheets_dir, file, media)
      #end

      #def add_sass(file, media=nil)
        #@sass << Assets::Sass.new(self, @sass_dir, file, media)
      #end

      #def add_css_files(files, media=nil)
        #files.each { |f| add_css(f, media) }
      #end

      #def add_sass_files(files, media=nil)
        #files.each { |f| add_sass(f, media) }
      #end

      def remove_jekyll_assets(files)
        files.each {|f| f.remove_jekyll_asset }
      end

      def add_asset_files(options)
        select_assets(options).each do |name, assets|
          assets.each {|file| file.add unless file.disabled? }
        end
      end

      def copy_asset_files(path, options)
        copied = []

        if options['stylesheets']
          options['css'] = true
          options['sass'] = true
          options.delete('stylesheets')
        end

        select_assets(options).each do |name, assets|
          next if name == 'docs'
          assets.each { |a| copied << a.copy(path) }
        end
        copied
      end

      def stylesheet_paths
        get_paths @css.reject{|f| f.disabled? }
      end

      def javascript_paths
        get_paths @javascripts.reject{|f| f.disabled? }
      end

      def stylesheet_tags
        get_tags @css.reject{|f| f.disabled? }
      end

      def css
        @css.reject{|f| f.disabled? }
      end

      def sass
        @sass.reject{|f| f.disabled? }
      end

      def sass_without_partials
        sass.reject{|f| f.file =~ /^_/ }
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
        @includes.find{|i| i.filename == file }.path
      end
    end
  end
end
