module ThemeKit
  class Template
    class << self
      attr_accessor :theme
    end

    def initialize
      @plugins = {}
    end

    def self.register_theme(name, theme)
      @theme = theme.new()
    end
    
    def self.register_plugin(name, plugin)
      @plugins[name] = plugin.new()
    end

    def self.all_stylesheets
      css = []
      plugins.each do |plugin| 
        css.concat plugin.stylesheets
      end
      css
    end
  end
end
