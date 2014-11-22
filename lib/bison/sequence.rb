module Bison
  class Sequence
    attr_accessor :rule, :index
    attr_reader :elements
    
    def initialize
      @elements = []
    end

    def <<(element)
      if Bison::Action === element
        element.predecessors = elements.clone
      end
      element.sequence = self
      elements << element
      self
    end
  end
end
