module Octopress
  module Ink
    module Assets
      class LocalSass < LocalStylesheet
        def initialize(plugin, base, file, media=nil)
          @plugin = plugin
          @file = file
          @base = base
          @root = Plugins.site.source
          @dir = base.sub(/^_/,'')
          @media = media || 'all'
        end

        def destination
          File.join(dir, file.sub(/@(.+?)\./,'.').sub(/s.ss/, 'css'))
        end

        def read
          compile
        end

        def compile
          AssetPipeline.compile_sass_file(path.to_s)
        end

        def add
          Plugins.site.static_files << StaticFileContent.new(compile, destination)
        end
      end
    end
  end
end

