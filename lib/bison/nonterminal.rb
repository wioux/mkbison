module Bison
  class Nonterminal
    attr_reader :name
    attr_reader :tag

    def initialize(name, tag=nil)
      @name = name
      @tag = tag
    end
  end
end
