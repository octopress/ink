# encoding: UTF-8
require 'yaml'

module Octopress
  module Ink
    module Configuration
      DEFAULTS = {
        'docs_mode' => false,
        'combine_css' => true,
        'compress_css' => true,
        'combine_js' => true,
        'uglify_js' => {},
        'disable' => [],
        'date_format' => 'ordinal',

        'linkpost' => {
          'marker' => "→",
          'marker_position' => 'after'
        },

        'post' => {
          'marker' => false,
          'marker_position' => 'before'
        }
      }

      def self.config
        @config ||= Jekyll::Utils.deep_merge_hashes(DEFAULTS, octopress_config)
      end

      def self.octopress_config
        if defined? Octopress.config
          Octopress.config
        else
          file = '_octopress.yml'
          if File.exist?(file)
            SafeYAML.load_file(file) || {}
          else
            {}
          end
        end
      end
    end
  end
end

