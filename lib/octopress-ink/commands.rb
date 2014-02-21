module Octopress
  module Ink
    module Commands
      require 'octopress-ink/commands/info'

      class Ink < Octopress::Command

        def self.init_with_program(p)
          p.command(:ink) do |c|
            c.syntax "octopress ink [options]"
            c.description "Get about octopress ink plugins"

            Info.process_command(c)

            c.action do |args, options|
            end
          end
        end
      end
    end
  end
end

