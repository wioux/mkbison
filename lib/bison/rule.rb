module Bison
  class Rule
    attr_reader :name, :components
    
    def initialize(name, components=[])
      @name, @components = name, components
    end
  end
end
