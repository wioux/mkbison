module Bison
  class Token
    attr_accessor :names
    attr_accessor :number
    attr_accessor :associativity
    
    def initialize(name, assoc=nil)
      self.names = Array(name)
      self.associativity = assoc
    end

    def name
      names.join(' ')
    end

    def left?
      associativity == :left
    end

    def right?
      associativity == :right
    end
  end
end
