require 'pastel'

module Vim
  module Flavor
    module Console
      class << self
        private def pastel
          @pastel ||= Pastel.new(enabled: $stdout.tty?)
        end

        def warn message
          puts pastel.yellow("Warning: #{message}")
        end

        def error message
          puts pastel.red("Error: #{message}")
          exit(1)
        end
      end
    end
  end
end
