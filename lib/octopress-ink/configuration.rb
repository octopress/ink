require 'yaml'

module Octopress
  module Ink
    module Configuration
      DEFAULTS = {
        'docs_mode' => false,
        'concat_css' => true,
        'concat_js' => true,
        'stylesheets_dir' => '_stylesheets',
        'javascripts_dir' => '_javascripts',
        'stylesheets' => [],
        'javascripts' => [],
        'disable' => []
      }

      def self.config
        @config ||= DEFAULTS.deep_merge(octopress_config)
      end

      def self.octopress_config
        if defined? Octopress.config
          Octopress.config
        else
          file = '_octopress.yml'
          if File.exist? file
            YAML.safe_load(File.open(file))
          else
            {}
          end
        end
      end
    end
  end
end

