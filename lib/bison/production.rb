module Bison
  class Production
    attr_reader :sequence

    def initialize
      @sequence = []
    end

    def push(e)
      @sequence.push(e)
    end
  end
end
