module Bison
  class Nonterminal
    attr_reader :name
    attr_reader :tag
    attr_accessor :location
    attr_accessor :sequence

    def initialize(name, tag=nil)
      @name = name
      @tag = tag
    end

    def to_bison
      name
    end
  end
end
