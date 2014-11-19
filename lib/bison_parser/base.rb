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

    def read
      io.read(1).tap do |c|
        if c == "\n"
          self.row += 1
          self.col = 0
        elsif c
          self.col += 1
        end
      end
    end

    def peak
      io.read(1).tap{ |c| io.ungetc(c) if c }
    end
  end

  include Base
end
