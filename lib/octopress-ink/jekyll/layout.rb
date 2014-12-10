module Octopress
  module Ink
    class Layout < Jekyll::Layout
      include Ink::Convertible

      # Initialize a new Layout.
      #
      # site - The Site.
      # base - The String path to the source.
      # name - The String filename of the post file.
      def initialize(site, base, name)
        @site = site
        @base = base
        @name = name

        self.data = {}

        process(name)
        read_yaml(base, name)
      end
    end
  end
end
