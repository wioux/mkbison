module Bison
  class Rule
    attr_reader :name, :components
    attr_accessor :location
    
    def initialize(name, components=[])
      @name, @components = name, components
      components.each_with_index{ |x, i| x.index = i; x.rule = self }
    end
  end
end
