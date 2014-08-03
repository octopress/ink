# encoding: UTF-8
require 'yaml'

module Octopress
  # Override Octopress configuration to Merge with Ink's defaults
  #
  class << self
    alias_method :orig_config, :config

    def config(options={})
      Jekyll::Utils.deep_merge_hashes(Ink::Configuration::DEFAULTS, orig_config(options))
    end
  end

  module Ink
    module Configuration
      DEFAULTS = {
        'docs_mode' => false,
        'combine_css' => true,
        'compress_css' => true,
        'combine_js' => true,
        'compress_js' => true,
        'uglifier' => {},
        'disable' => [],
        'date_format' => 'ordinal',
      }
    end
  end
end

