require 'octopress-ink'

module Octopress
  class LocalBootstrap < Ink::Plugin
    def reset
      super
      @local_layout_dir = Jekyll::LayoutReader.new(Octopress.site).layout_directory
    end

    def find_template(name)
      if local && layout = Octopress.site.layouts.values.find { |l| l.name == name }
        @templates << Ink::Assets::LocalTemplate.new(self, @local_layout_dir, layout)
        @templates.last
      else
        super(name)
      end
    end
  end
end

Octopress::Ink.register_plugin(Octopress::LocalBootstrap, {
  name:        "Bootstrap Local",
  description: "Bootstrap local layouts",
  path:         File.expand_path(File.dirname(__FILE__)),
  local: true
})
