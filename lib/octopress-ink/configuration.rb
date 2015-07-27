# encoding: UTF-8

module Octopress
  module Ink
    DEFAULT_OPTIONS = {
      'asset_pipeline' => {
        'combine_css' => true,
        'compress_css' => true,
        'combine_js' => true,
        'compress_js' => true,
        'uglifier' => {},
        'async_css' => false,
        'async_js' => true,
        'stylesheets_destination' => 'stylesheets',
        'javascripts_destination' => 'javascripts',
      },

      'date_format' => 'ordinal',
    }

    def self.configuration(options={})
      @config ||= Jekyll::Utils.deep_merge_hashes(DEFAULT_OPTIONS, Octopress.configuration(options))
    end

  end
end

