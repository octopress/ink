module ThemeKit
  class Plugins

    def self.theme
      @plugins['theme']
    end
    
    def self.register_theme(theme)
      register_plugin 'theme', theme
    end

    def self.register_plugin(name, plugin)
      @plugins ||= {}
      @plugins[name] = plugin.new(name)
    end

    def self.stylesheets(site)
      css = []
      @plugins.values.each do |plugin| 
        css.concat plugin.stylesheets(site)
      end
      css
    end

    def self.stylesheet_tags(site)
      css = []
      @plugins.values.each do |plugin| 
        css.concat plugin.stylesheet_tags(site)
      end
      css
    end

    def self.javascripts(site)
      css = []
      @plugins.values.each do |plugin| 
        css.concat plugin.javascripts(site)
      end
      css
    end

    def self.javascript_tags(site)
      css = []
      @plugins.values.each do |plugin| 
        css.concat plugin.javascript_tags(site)
      end
      css
    end

  end
end
