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
          website:     "http://octopress.org/docs/ink",
          docs_url:    "docs/ink"
        }
      end
    end
  end
end
