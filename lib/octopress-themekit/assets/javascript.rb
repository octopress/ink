module ThemeKit
  class Javascript < Asset

    def tag(base_url)
      "<script src='/#{File.join(@dir, @file)}'></script>"
    end
  end
end
