module ThemeKit
  class Javascript < Asset
    def tag
      "<script src='/#{File.join(@dir, @file)}'></script>"
    end
  end
end
