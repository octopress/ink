module Octopress
  module Ink
    module Assets
      class LocalJavascript < LocalAsset
        def tag
          "<script src='#{Filters.expand_url(File.join(dir, file))}'></script>"
        end
      end
    end
  end
end

