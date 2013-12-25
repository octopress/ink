module ThemeKit
  class Stylesheet
    def initialize(path, media)
      @path = path
      @media = media || 'all'
    end

    def path
      @path
    end

    def link(base_url)
      "<link href='/#{File.join(base_url, path)}' media='#{@media}' rel='stylesheet' type='text/css'>"
    end
  end
end
