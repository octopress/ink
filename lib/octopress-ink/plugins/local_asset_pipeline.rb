# The CSS assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  module Ink
    class AssetPipelinePlugin < Plugin
      def configuration
        {
          name:        "Octopress Ink Asset Pipeline",
          description: "Adds your Sass, CSS, Coffeescript and Javascript to the Octopres asset pipeline.",
          local:       true
        }
      end

      def config
        @config ||= Ink.config
      end

      def register
        # Tell Jekyll to read static files and pages
        # This is necessary when Jekyll isn't being asked to build a site,
        # like when a user runs the list command to list assets
        #
        if Ink.site.pages.empty? && Ink.site.posts.empty?
          Ink.site.read_directories 
        end

        if Ink.config['concat_css']
          add_stylesheets
        end
        if Ink.config['concat_js']
          add_javascripts
        end
      end

      def stylesheets
        @css.clone.concat @sass
      end

      def javascripts
        @js.clone.concat @coffee
      end

      private

      def add_stylesheets
        add_sass
        add_css
      end

      def add_javascripts
        add_js
        add_coffee
      end

      # Finds all Sass files registered by Jekyll
      #
      def add_sass
        Ink.site.pages.each do |f| 
          if f.ext =~ /\.s[ca]ss/ 
            @sass << Assets::LocalSass.new(self, Ink.site.pages.delete(f))
          end
        end
      end

      # Finds all CSS files registered by Jekyll
      #
      def add_css
        Ink.site.static_files.each do |f| 
          if f.path =~ /\.css$/ 
            @css << Assets::LocalStylesheet.new(self, Ink.site.static_files.delete(f))
          end
        end
      end

      # Finds all Coffeescript files registered by Jekyll
      #
      def add_coffee
        Ink.site.pages.each do |f| 
          if f.ext =~ /\.coffee$/ 
            @coffee << Assets::LocalCoffeescript.new(self, Ink.site.pages.delete(f))
          end
        end
      end

      # Finds all Javascript files registered by Jekyll
      #
      def add_js
        Ink.site.static_files.each do |f| 
          if f.path =~ /\.js$/ 
            @js << Assets::LocalAsset.new(self, Ink.site.static_files.delete(f))
          end
        end
      end
    end
  end
end

