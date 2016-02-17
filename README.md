# mkbison

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'mkbison'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mkbison

You'll need to install [GNU Bison](https://www.gnu.org/software/bison/) as well, e.g.:

    $ sudo apt-get install bison

## Usage and Example

The gem installs a command `mkbison` which translates `.rby` files into `.y` Bison grammar files, and generates a native ruby extension to expose the resulting parser.

`.rby` files contain a grammar definition and ruby code. Their syntax mostly mirrors that of Bison grammar files, with the following differences:

   * Actions are written in ruby, rather than C (as is the lex section).
   * Positional references to semantic values are not allowed.
   * [Named references](http://www.gnu.org/software/bison/manual/html_node/Named-References.html) should not use a dollar sign `$`.

For example, here is a mkbison grammar for parsing very simple arithmetic expressions:

**arithmetic.rby**
```yacc
%token NUMBER

%left OP_PLUS
%left OP_MINUS

%%

arithmetic:
  expression[x]
  { self.result = x }
;

expression :
  NUMBER
| addition
| subtraction
;

addition :
  expression[left] OP_PLUS expression[right]
  { left + right }
;

subtraction :
  expression[left] OP_MINUS expression[right]
  { left - right }
;

%%

class Arithmetic
  def lex
    # skip space
    while true
      while (c = self.read) && c =~ /\s/
      end

      if c == '#'
        while (char = self.read) && char != "\n"
        end
      else
        break
      end
    end

    case c
    when '0'..'9'
      number = c
      while (c = self.peak) && ('0'..'9').include?(c)
        number << self.read
      end

      self.lex_value = number.to_i
      return Tokens::NUMBER

    when '+'
      return Tokens::OP_PLUS

    when '-'
      return Tokens::OP_MINUS
    end

    nil
  end
end
```

To translate it into a Bison grammar file, run

    $ bundle exec mkbison -n Arithmetic -o . arithmetic.rby
    $ rake compile

This will generate and build a native extension named `arithmetic` in the current directory. A class named `Arithmetic` exposes the grammar parser. We can perform calculations now with `Arithmetic.new(expression).parse` which will return the result (or raise an exception if a syntax error is encountered).

## TODO
  * Support multiple tokens on %left/%right lines, for same precedence
  * Automatically create Rakefile task
  * Change the parsers initialize() behavior (don't assume argument is file path)

  * Seems like you can hit EOF in the middle of action block and get wrong error msg
  * Benchmark -- what takes so long on the koa grammar?
  * Write to temp files, then move them into place
  * Move base module into the c extension and document the lexing helpers

Not all Bison features are supported yet.

## Contributing

1. Fork it ( https://github.com/wioux/mkbison )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
