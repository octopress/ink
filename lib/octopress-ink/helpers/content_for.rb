module Octopress
  module Helpers
    module ContentFor
      def self.get_block_name(tag_name, markup)
        if markup.strip == ''
          raise IOError.new "Syntax Error: #{tag_name} requires a name, eg. {% #{tag_name} sidebar %}"
        else
          markup.strip
        end
      end

      # Gets the storage space for the content block
      def self.get_block(context, block)
        context.environments.first['content_for'] ||= {}
        context.environments.first['content_for'][block] ||= []
      end

      def self.render(context, block)
        content = get_block(context, block).map { |b| b }.join
      end

      def self.append_to_block(context, block, content)
        converter = context.environments.first['converter']
        content = converter.convert(content).lstrip
        get_block(context, block) << content
      end
    end
  end
end
