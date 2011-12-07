require 'logger'

module Google
  module Maps
    module Logger

      attr_accessor :logger
          
      def log_file=(file)
        self.logger = ::Logger.new(file)
      end
      
      def self.extended(base)
        base.log_file = "/dev/null"
      end
    end
  end
end
