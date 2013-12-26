module ThemeKit
  class Javascripts < Jekyll::Generator
    def generate(site)
      Plugins.javascripts(site)
    end
  end
end
