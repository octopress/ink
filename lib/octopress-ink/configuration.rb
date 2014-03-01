module Octopress
  module Ink
    module Configuration
      DEFAULTS = {
        'docs_mode' => false,
        'concat_css' => true,
        'concat_js' => true,
        'stylesheets_dir' => '_stylesheets',
        'javascripts_dir' => '_javascripts'
      }

      def self.config
        @config ||= DEFAULTS.deep_merge(Octopress.config)
      end
    end
  end
end

