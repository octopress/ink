module Octopress
  module Ink
    module Commands
      require 'octopress-ink/commands/info'
      require 'octopress-ink/commands/copy'

      class Ink < Octopress::Command

        def self.init_with_program(p)
          p.command(:ink) do |c|
            c.syntax "octopress ink [options]"
            c.description "Get about octopress ink plugins"

            Info.process_command(c)
            Copy.process_command(c)
          end
        end
      end
    end
  end
end

