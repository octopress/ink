module ThemeKit
  class Sass < Asset
    def initialize(plugin, type, file, media)
      @file = file
      @plugin_type = plugin.type
      @root = plugin.assets_path
      @dir = File.join(plugin.namespace, type)
      @exists = {}
      @media = media || 'all'
    end

    def media
      @media
    end

    def tag
      "<link href='/#{File.join(@dir, @file)}' media='#{@media}' rel='stylesheet' type='text/css'>"
    end

    def user_load_path(site)
      File.join site.source, Plugins.theme_dir(site), @dir, File.dirname(@file)
    end

    def theme_load_path
      File.expand_path(File.join(@root, @dir))
    end

    # Remove sass files from Jekyll's static_files array so it doesn't end up in the
    # compiled site directory. 
    #
    def remove_static_file(site)
      site.static_files.clone.each do |sf|
        if sf.kind_of?(Jekyll::StaticFile) && sf.path == path(site).to_s
          site.static_files.delete(sf)
        end
      end
    end

    def compile(site)
      unless @compiled
        options = Plugins.sass_options(site)
        if @plugin_type == 'local_plugin'
          remove_static_file(site)
          @compiled = Plugins.compile_sass_file(path(site).to_s, options)
        else
          # If the plugin isn't a local plugin, add source paths to allow overrieds on @imports.
          #
          options[:load_paths] = [user_load_path(site), theme_load_path]
          @compiled = Plugins.compile_sass_file(path(site).to_s, options)
        end
      end

      @compiled
    end

    def copy(site)
      site.static_files << ThemeKit::StaticFileContent.new(compile(site), destination)
    end
  end
end
