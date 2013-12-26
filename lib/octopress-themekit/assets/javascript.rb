module ThemeKit
  class Javascript
    attr_accessor :path

    def initialize(path)
      @path = path
    end

    def tag(base_url)
      "<script src='/#{File.join(base_url, path)}'></script>"
    end
  end
end
