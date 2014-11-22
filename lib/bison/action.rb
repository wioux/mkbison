module Bison
  class Action
    attr_accessor :code
    attr_accessor :location
    
    def initialize(code)
      self.code = code
    end

    def to_bison
      ''
    end
  end
end
