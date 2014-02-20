module Octopress
  module Ink
    module Tags
      class AbortTag < Liquid::Tag
        def initialize(tag_name, markup, tokens)
          super
          @markup = " #{markup}"
        end

        def render(context)
          if Helpers::Conditional.parse(@markup, context)
            env = context.environments.first
            dest = File.join(Helpers::Path.site_dir, env['page']['url'])
            context.environments.first['site']['pages'] = Helpers::Path.remove_page(dest)
          end
          ''
        end
      end
    end
  end
end

