module Octopress
  module Ink
    module Assets
      class Coffeescript < Javascript
        def read
          @compiled ||= compile
        end

        private

        def compile
          ::CoffeeScript.compile(render)
        end

        def destination
          File.join(base, plugin.slug, file.sub(/\.coffee/,'.js'))
        end
      end
    end
  end
end

