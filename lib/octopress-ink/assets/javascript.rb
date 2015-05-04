module Octopress
  module Ink
    module Assets
      class Javascript < Asset
        def tag
          %Q{<script src="#{tag_path}"></script>}
        end

        def tag_path
          Filters.expand_url(File.join(dir, file))
        end

        def add
          Plugins.add_js_tag tag
          super
        end

        def destination
          File.join(base, plugin.slug, file)
        end
      end
    end
  end
end

