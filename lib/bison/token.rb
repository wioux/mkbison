module Bison
  class Token
    attr_accessor :name
    attr_accessor :associativity
    
    def initialize(name, assoc=nil)
      self.name = name
      self.associativity = assoc
    end

    def left?
      associativity == :left
    end

    def right?
      associativity == :right
    end
  end
end
