class BisonParser
  attr_reader :io
  attr_accessor :lex_value, :token_row, :token_col, :row, :col
  attr_accessor :source, :result

  module Base
    def initialize(io)
      if String === io
        io = ::File.open(io, 'r')
      end
      @source = io.respond_to?(:path) ? io.path : nil
      @io, @row, @col = io, 1, 0
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

    def begin_token
      self.token_row = row
      self.token_col = col
    end

    def error(msg, row, col)
      raise Error.new(msg, source, row, col)
    end
  end

  include Base

  class Error < ::Exception
    attr_reader :message
    def initialize(msg, source, row, col)
      source ||= '-'
      @message = "#{source}:#{row}.#{col} #{msg}"
    end
  end
end
