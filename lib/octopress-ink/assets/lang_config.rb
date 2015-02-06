module Octopress
  module Ink
    module Assets
      class LangConfig < Config
        attr_reader :lang

        def initialize(plugin, path, lang)
          super(plugin, path)
          @lang = lang
        end
      end
    end
  end
end

