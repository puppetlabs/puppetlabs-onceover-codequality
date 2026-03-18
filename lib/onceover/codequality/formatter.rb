class Onceover
  module CodeQuality
    module Formatter
      START_TEST = "Checking".freeze
      MSG_TEST_OK = "...OK".freeze

      def self.start_test(test_name)
        logger.info "Checking #{test_name}..."
      end

      def self.end_test(output, ok, show_output = false)
        if !ok || show_output
          output.each_line do |line|
            if line.start_with?('::') # This is special syntax for GitHub annotations
              puts(line)
            else
              logger.info("\t#{line.chomp}")
            end
          end
        end

        if ok
          logger.info "...OK"
        else
          logger.error "...FAILED"
        end
      end
    end
  end
end
