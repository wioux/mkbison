module Bison
  class Nonterminal
    attr_reader :name
    attr_reader :tag
    attr_accessor :location

    def initialize(name, tag=nil)
      @name = name
      @tag = tag
    end
  end
end
