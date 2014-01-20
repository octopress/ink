module Jekyll
  module Convertible
    alias_method :do_layout_orig, :do_layout

    def do_layout(payload, layouts)
      # The contentblock tags needs access to the converter to process it while rendering.
      config = Octopress::Plugins.config(payload['site'])
      payload['plugins']   = config['plugins']
      payload['theme']     = config['theme']
      payload['converter'] = self.converter
      do_layout_orig(payload, layouts)
    end
  end
end
