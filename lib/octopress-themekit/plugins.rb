module ThemeKit
  class Plugins
    LAYOUTS_DIR     = 'layouts'
    EMBEDS_DIR      = 'embeds'
    JAVASCRIPTS_DIR = 'javascripts'
    STYLESHEETS_DIR = 'stylesheets'

    def self.theme
      plugin('theme')
    end

    def self.plugin(name)
      if @plugins[name]
        @plugins[name]
      else
        raise IOError.new "No layout such layout #{name} for #{name}."
      end
    end

    def self.layout(name, file, site)
      plugin(name).layout(file, site)
    end

    def self.embed(name, file, site)
      plugin(name).embed(file, site)
    end
    
    def self.register_theme(theme)
      register_plugin 'theme', theme
    end

    def self.register_plugin(name, plugin)
      @plugins ||= {}
      @plugins[name] = plugin.new(name)
    end

    def self.theme_dir(site)
      site.config['custom'] || CUSTOM_DIR
    end

    def self.fingerprint(paths)
      paths = [paths] unless paths.is_a? Array
      Digest::MD5.hexdigest(paths.dup.map! { |path| "#{File.mtime(path).to_i}" }.join)
    end
    
    def self.combined_stylesheet_path(media)
      File.join(STYLESHEETS_DIR, "site-#{media}-#{@combined_stylesheets[media][:fingerprint]}.css")
    end

    def self.combined_javascript_path
      print = @javascript_fingerprint || ''
      File.join(JAVASCRIPTS_DIR, "site-#{print}.js")
    end

    def self.write_files(site, source, dest)
      site.static_files << ThemeKit::StaticFileContent.new(source, dest)
    end

    def self.copy_files(site, source, dest)
      site.static_files << ThemeKit::StaticFile.new(source, dest)
    end

    def self.write_combined_stylesheet(site)
      css = combine_stylesheets(site)
      css.keys.each do |media|
        write_files(site, css[media][:contents], combined_stylesheet_path(media)) 
      end
    end

    def self.write_combined_javascript(site)
      write_files(site, combine_javascripts(site), combined_javascript_path) 
    end

    def self.combine_stylesheets(site)
      unless @combined_stylesheets
        css = {}
        @plugins.values.each do |plugin|
          plugin.stylesheets.each do |file|
            css[file.media] ||= []
            css[file.media] << file.path(site)
          end
        end

        files = {}
        css.keys.each do |media|
          paths = css[media]
          combined = ''
          paths.each { |p| combined.concat Pathname.new(p).read }
          files[media] = {
            contents: combined,
            fingerprint: fingerprint(paths)
          }
        end
        @combined_stylesheets = files
      end
      @combined_stylesheets
    end

    def self.combine_javascripts(site)
      js = ''
      @plugins.values.each do |plugin| 
        paths = plugin.javascript_paths(site)
        @javascript_fingerprint = fingerprint(paths)
        paths.each do |file|
          js.concat Pathname.new(file).read
        end
      end
      js
    end

    def self.combined_stylesheet_tag(site)
      tags = ''
      combine_stylesheets(site).keys.each do |media|
        tags.concat "<link href='/#{combined_stylesheet_path(media)}' media='#{media}' rel='stylesheet' type='text/css'>"
      end
      tags
    end

    def self.combined_javascript_tag
      "<script src='/#{combined_javascript_path}'></script>"
    end

    def self.stylesheet_tags
      css = []
      @plugins.values.each do |plugin| 
        css.concat plugin.stylesheet_tags
      end
      css
    end

    def self.javascript_tags
      js = []
      @plugins.values.each do |plugin| 
        js.concat plugin.javascript_tags
      end
      js
    end


    def self.copy_javascripts(site)
      @plugins.keys.each do |name| 
        @plugins[name].javascript_paths(site).each do |path|
          copy_files(site, path, dest_path(@plugins[name], path.to_s, JAVASCRIPTS_DIR))
        end
      end
    end

    def self.copy_stylesheets(site)
      @plugins.keys.each do |name| 
        @plugins[name].stylesheet_paths(site).each do |path|
          copy_files(site, path, dest_path(@plugins[name], path.to_s, STYLESHEETS_DIR))
        end
      end
    end

    def self.dest_path(plugin, path, dir)
      sub_path = path.split(dir)[1]
      File.join(plugin.name, dir, sub_path)
    end

  end
end
