module ThemeKit
  class Javascripts < Jekyll::Generator
    def generate(site)
      Template.theme.javascripts(site)
    end
  end
end
