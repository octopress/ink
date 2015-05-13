module Octopress
  module Ink
    module Assets
      class Coffeescript < Javascript

        def tag_path
          Filters.expand_url(File.join(dir, File.basename(file, '.*') << '.js'))
        end

        def add
          Plugins.add_js_tag tag
          Plugins.static_files << StaticFileContent.new(content, destination)
        end

        def content
          begin
            require 'jekyll-coffeescript'
          rescue LoadError
            raise "Add gem jekyll-coffeescript to Gemfile (or gemspec)."
          end
          ::CoffeeScript.compile(super)
        end

        def destination
          File.join(base, plugin.slug, File.basename(file, '.*') << '.js')
        end
      end
    end
  end
end

