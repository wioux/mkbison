# mkbison

`mkbison` is a tool to create native ruby extensions containing [GNU Bison](https://www.gnu.org/software/bison/) generated LALR(1) grammar parsers.

## Installation

Add these lines to your application's Gemfile:

    gem 'mkbison'
    gem 'rake-compiler'

You'll need to install a GNU Bison version >= 3.0.0 as well, with e.g.:

    $ sudo apt-get install bison

## Usage and Example

`mkbison` operates on grammar files with a syntax which mostly mirrors the Bison grammar. For example, here is a file which describes basic arithmetic:

**[arithmetic.rby](https://github.com/wioux/mkbison/blob/master/examples/arithmetic/arithmetic.rby)**
```yacc

%token NUMBER
%token LPAREN
%token RPAREN

%left OP_PLUS  OP_MINUS
%left OP_TIMES OP_OVER

%%

arithmetic:
  expression[x]
  { self.result = x }
;

expression :
  NUMBER
| OP_MINUS expression[x]
  { -x }
| LPAREN expression[x] RPAREN
  { x }
| addition
| subtraction
| multiplication
| division
;

addition :
  expression[left] OP_PLUS expression[right]
  { left + right }
;

subtraction :
  expression[left] OP_MINUS expression[right]
  { left - right }
;

multiplication:
  expression[left] OP_TIMES expression[right]
  { left * right }
;

division:
  expression[left] OP_OVER expression[right]
  { left / right }
;

%%

class Arithmetic
  def lex
    c = read_over_whitespace
    case c
    when '0'..'9'
      number = read_integer(c)
      self.lex_value = number.to_i
      return Tokens::NUMBER

    when '+'
      return Tokens::OP_PLUS

    when '-'
      return Tokens::OP_MINUS

    when '*'
      return Tokens::OP_TIMES

    when '/'
      return Tokens::OP_OVER

    when '('
      return Tokens::LPAREN

    when ')'
      return Tokens::RPAREN

    else
      return nil
    end
  end
end
```

The structure here should be recognizable to those familiar with GNU Bison. If you aren't, you might want to [read up on its usage](https://www.gnu.org/software/bison/manual/html_node/index.html) before using `mkbison`.

There are three sections:

   1) Token and precedence definitions
   2) The description of the grammar
   3) The lexing implementation

To compile this into a ruby extension which we can use to calculate basic arithmetic expressions, first run `mkbison`:

    $ bundle exec mkbison -n Arithmetic arithmetic.rby

This creates the ruby extension in the current directory (under `lib/` and `ext/` directories). The Bison translation of the grammar can be found at `ext/arithmetic/arithmetic.y`. Once compiled, we'll be able to require it as `'arithmetic'` and use it with `Arithmetic.new(expression).parse`.

Next we'll need to create a `rake` task as follows:

**[Rakefile](https://github.com/wioux/mkbison/blob/master/examples/arithmetic/Rakefile)**
```ruby
require "rake/extensiontask"

Rake::ExtensionTask.new "arithmetic" do |ext|
  ext.lib_dir = "lib/arithmetic"
end
```

Once we have that, we can compile our extension simply by running

    $ rake compile

## TODO
  * Add tests
  * Support string/character literals in grammar rules
  * Automatically create Rakefile task
  * Write to temp files, then move them into place
  * Move base module into the c extension and document the lexing helpers
  * Seems like you can hit EOF in the middle of action block and get wrong error msg
  * Benchmark -- what takes so long on the koa grammar?

Not all Bison features are supported yet...

## Contributing

1. Fork it ( https://github.com/wioux/mkbison )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
