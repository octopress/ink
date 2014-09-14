module Octopress
  module Ink
    class InkPlugin < Octopress::Ink::Plugin
      def configuration
        {
          name:        "Octopress Ink",
          slug:        "ink",
          path:        Octopress::Ink.gem_dir,
          version:     Octopress::Ink::VERSION,
          description: "Octopress Ink is a plugin framework for Jekyll",
          website:     "http://octopress.org/docs/ink"
        }
      end

      def docs_base_url
        'docs/ink'
      end

      def info(options)
        if options['docs']
          super
        else
          ''
        end
      end
    end
  end
end
