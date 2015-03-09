module Octopress
  module Ink
    module Assets
      class LocalTemplate < Template

        def initialize(plugin, layout)
          super(plugin, base, file)
        end

        def path
          File.join(base, file)
        end
      end
    end
  end
end
