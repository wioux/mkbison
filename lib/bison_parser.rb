
class BisonParser
  attr_accessor :section

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
      nesting = 1
      action = ''
      while (c = self.read) && nesting > 0
        nesting += 1 if c == '{'
        nesting -= 1 if c == '}'
        action << c unless nesting.zero?
      end
      self.lex_value = action
      return Tokens::ACTIONS
    when '0'..'9'
      number = c
      while (c = self.peak) && ('0'..'9').include?(c)
        number << self.read
      end
      self.lex_value = number.to_i
      return Tokens::NUMBER
    end

    if c =~ /\w/
      string = c
      while (c = self.peak) && c =~ /\w/
        self.read
        string << c
      end

      if section.zero? && string == 'token'
        return Tokens::KW_TOKEN
      elsif section.zero? && string == 'left'
        return Tokens::KW_LEFT
      elsif section.zero? && string == 'right'
        return Tokens::KW_RIGHT
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
