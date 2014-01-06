# The sass assets for this plugin are populated at runtime by the add_static_files method of
# the Plugins module.
#
module Octopress
  class SassPlugin < Octopress::Plugin
    def add_files(files)
      files = [files] unless files.is_a? Array
      files.each do |file|
        if file.is_a? Array
          add_sass file.first, file.last
        else
          add_sass file
        end
      end
    end
  end
end

