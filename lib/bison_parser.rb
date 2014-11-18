class BisonParser
  attr_accessor :section

  def error(msg, row, col)
    abort("#{row}.#{col}: #{msg}")
  end

  def lex
    self.section ||= 0
    self.lex_value = nil

    if section == 2
      self.lex_value = io.read
      self.section += 2
      return Tokens::ACTIONS
    end

    # skip space
    while (c = io.read(1)) && c =~ /\s/
      if c == "\n"
        self.row += 1
        self.col = 0
      else
        self.col += 1
      end
    end
    
    return nil unless c

    peak = io.read(1)
    io.ungetc(peak) if peak

    case c
    when ':'
      return Tokens::COLON
    when ';'
      return Tokens::SEMICOLON
    when '|'
      return Tokens::PIPE
    when '%'
      if peak == '%'
        io.read(1)
        self.col += 1
        self.section += 1
        return Tokens::DOUBLE_HASH
      end
      return Tokens::HASH
    when '{'
      action = ''
      while (c = io.read(1))
        break if c == '}'
        action << c
        if c == "\n"
          self.row += 1
          self.col = 0
        else
          self.col += 1
        end
      end
      self.lex_value = action
      return Tokens::ACTIONS
    end

    if c =~ /\w/
      string = c
      while (c = io.read(1)) && c =~ /\w/
        string << c
        self.col += 1
      end

      io.ungetc(c) if c

      case string
      when 'token'
        return Tokens::KW_TOKEN
      else
        self.lex_value = string
        return Tokens::IDENTIFIER
      end
    end

    return nil
  end
end

require 'bison_parser/base'
require 'bison_parser/tokens'
require 'bison_parser/actions'
require 'bison_parser/bison_parser'
