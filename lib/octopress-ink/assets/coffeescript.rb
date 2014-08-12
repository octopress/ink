module Octopress
  module Ink
    module Assets
      class Coffeescript < Javascript
        def add
          Plugins.add_js_tag tag
          Plugins.static_files << StaticFileContent.new(compile, destination)
        end

        def compile
          ::CoffeeScript.compile(content)
        end

        def destination
          File.join(base, plugin.slug, file.sub(/\.coffee/,'.js'))
        end
      end
    end
  end
end

