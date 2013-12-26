module ThemeKit
  class Stylesheets < Jekyll::Generator
    def generate(site)
      Template.theme.stylesheets(site)
    end
  end
end
