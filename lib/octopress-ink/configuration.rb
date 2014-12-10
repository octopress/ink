# encoding: UTF-8
require 'yaml'

module Octopress
  module Ink
    DEFAULT_OPTIONS = {
      'combine_css' => true,
      'compress_css' => true,
      'combine_js' => true,
      'compress_js' => true,
      'uglifier' => {},
      'disable' => [],
      'date_format' => 'ordinal',
    }

    def self.configuration(options={})
      @config ||= DEFAULT_OPTIONS.merge(Octopress.configuration(options))
    end

  end
end

