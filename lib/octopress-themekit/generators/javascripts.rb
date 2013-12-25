module ThemeKit
  class Javascripts < Jekyll::Generator
    def generate(site)
      Template.theme.output_javascripts(site)
    end
  end
end
