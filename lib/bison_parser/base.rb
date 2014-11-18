class BisonParser
  attr_reader :io
  attr_accessor :lex_value, :result, :row, :col

  module Base
    def initialize(io)
      if String === io
        io = ::File.open(io, 'r')
      end
      @io, @row, @col = io, 0, 0
    end
  end

  include Base
end
