module Octopress
  module Ink
    module Assets
      class LocalTemplate < Template
        def initialize(plugin, base, layout)
          @layout = layout
          super(plugin, base, layout.name)
        end

        def path
          plugin_path
        end

        def plugin_path
          File.join(base, file)
        end
      end
    end
  end
end
