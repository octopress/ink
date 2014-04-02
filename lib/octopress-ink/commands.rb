module Octopress
  module Ink
    module Commands
      require 'octopress-ink/commands/list'
      require 'octopress-ink/commands/copy'
      require 'octopress-ink/commands/new'
      require 'octopress-ink/commands/init'

      class Ink < Octopress::Command

        def self.init_with_program(p)
          p.command(:ink) do |c|
            c.version Octopress::Ink::VERSION
            c.description "Work with your Octopress Ink plugins."
            c.syntax "ink <subcommand>"

            c.action do |args, options|
              puts c if args.empty?
            end

            List.process_command(c)
            Copy.process_command(c)
            New.process_command(c)
            Init.process_command(c)
          end
        end
      end
    end
  end
end

