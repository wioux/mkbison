
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
    while (c = self.read) && c =~ /\s/
    end
    
    return nil unless c

    case c
    when ':'
      return Tokens::COLON
    when ';'
      return Tokens::SEMICOLON
    when '|'
      return Tokens::PIPE
    when '%'
      if self.peak == '%'
        self.read
        self.section += 1
        return Tokens::DOUBLE_HASH
      end
      return Tokens::HASH
    when '['
      return Tokens::LBRACK
    when ']'
      return Tokens::RBRACK
    when '{'
      action = ''
      while (c = self.read) && (c != '}')
        action << c
      end
      self.lex_value = action
      return Tokens::ACTIONS
    end

    if c =~ /\w/
      string = c
      while (c = self.read) && c =~ /\w/
        string << c
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
require 'bison_parser/actions'
require 'bison_parser/bison_parser'
