module Octopress
  module Ink
    module Assets
      class Coffeescript < Javascript
        def tag
          "<script src='#{Filters.expand_url(File.join(dir, file.sub(/\.coffee$/,'.js')))}'></script>"
        end

        def add
          Plugins.add_js_tag tag
          Plugins.static_files << StaticFileContent.new(content, destination)
        end

        def content
          ::CoffeeScript.compile(super)
        end

        def destination
          File.join(base, plugin.slug, file.sub(/\.coffee/,'.js'))
        end
      end
    end
  end
end

