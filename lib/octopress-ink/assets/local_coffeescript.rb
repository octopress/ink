module Octopress
  module Ink
    module Assets
      class LocalCoffeescript < LocalAsset
        def read
          compile
        end

        def content
          file.content
        end

        def path
          File.join(file.site.source, file.path)
        end

        def compile
          ::CoffeeScript.compile(content)
        end
      end
    end
  end
end

