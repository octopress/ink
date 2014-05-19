module Octopress
  module Ink
    module Assets
      class LocalStylesheet < LocalAsset
        def media
          path.scan(/@(.+?)\./).flatten[0] || 'all'
        end
      end
    end
  end
end

