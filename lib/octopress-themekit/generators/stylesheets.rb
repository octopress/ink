module ThemeKit
  class Stylesheets < Jekyll::Generator
    def generate(site)
      Template.theme.output_stylesheets(site)
    end
  end
end
