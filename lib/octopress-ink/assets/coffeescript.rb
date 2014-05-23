module Octopress
  module Ink
    module Assets
      class Coffeescript < Javascript
        def read
          @compiled ||= compile
        end

        def add
          Plugins.add_js_tag tag
          Plugins.static_files << StaticFileContent.new(read, destination)
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

