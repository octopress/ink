require 'json'

module Octopress
  module Ink
    module Utils
      extend self

      def pretty_print_yaml(yaml)
        # Use json pretty_print, but make it look like yaml
        #
        JSON.pretty_generate(yaml)
          .sub(/\A{\n/,'')          # remove leading {
          .sub(/}\z/,'')            # remove trailing }
          .gsub(/^/,' ')            # indent
          .gsub(/"(.+?)":/,'\1:')   # remove quotes around keys
          .gsub(/,$/,'')            # remove commas from end of lines
          .gsub(/{\n/,"\n")         # remove keys with empty hashes
          .gsub(/^\s+}\n/,'')       # remove keys with empty hashes
          .gsub(/\[\s+\]/,'[]')       # remove whitespace in empty arrays
      end
    end
  end
end
