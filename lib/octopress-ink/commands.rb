module Octopress
  module Ink
    module Commands
      require 'octopress-ink/commands/info'
      require 'octopress-ink/commands/copy'

      class Ink < Octopress::Command

        def self.init_with_program(p)
          p.command(:ink) do |c|
            c.version Octopress::Ink::VERSION
            c.description "Get informationa about and work with Octopress Ink plugins."
            c.syntax "ink <subcommand>"

            Info.process_command(c)
            Copy.process_command(c)
          end
        end
      end
    end
  end
end

