require_relative './jumpstarter_core/setup'
module Jumpstarter
  class Runner
    class << self
      def setup
        Setup.setup!
      end
    end
  end
end
