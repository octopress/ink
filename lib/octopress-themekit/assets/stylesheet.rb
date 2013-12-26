module ThemeKit
  class Stylesheet
    attr_accessor :path

    def initialize(path, media)
      @path = path
      @media = media || 'all'
    end

    def tag(base_url)
      "<link href='/#{File.join(base_url, path)}' media='#{@media}' rel='stylesheet' type='text/css'>"
    end
  end
end
