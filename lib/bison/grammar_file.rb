module Bison
  class GrammarFile
    attr_accessor :name
    attr_reader :tokens, :rules, :code

    def initialize(tokens, rules, code)
      @tokens, @rules, @code = tokens, rules, code
    end

    def print_class(out=$stdout)
      out.puts("class #{name}")
      out.puts("end")
      out.puts

      out.puts("require '#{uname}/base'")
      out.puts("require '#{uname}/tokens'")
      out.puts("require '#{uname}/actions'")
      out.puts("require '#{uname}/#{uname}'")
    end

    def print_base_module(out=$stdout)
      out.puts("class #{name}")
      out.puts("  attr_reader :io, :result")
      out.puts("  attr_accessor :row, :col")
      out.puts
      
      out.puts("  module Base")
      out.puts("    def initialize(io)")
      out.puts("      if String === io")
      out.puts("        io = ::File.open(io, 'r')")
      out.puts("      end")
      out.puts("      @io, @row, @col = io, 0, 0")
      out.puts("    end")
      out.puts("  end")
      out.puts

      out.puts("  include Base")
      out.puts("end")
    end

    def print_tokens_module(out=$stdout)
      out.puts("class #{name}")
      out.puts("  module Tokens")
      
      tokens.each_with_index do |token, i|
        out.puts("    #{token} = #{300+i}")
      end

      out.puts("  end")
      out.puts("end")
    end

    def print_actions_module(out=$stdout)
      out.puts("class #{name}")
      out.puts("  module Actions")

      rules.values.flatten.select(&:action).each_with_index do |rule, i|
        out.puts unless i.zero?
        out.puts("    def #{rule.action_name}(#{rule.tags.values.join(', ')})")
        out.puts("      #{rule.action.strip}")
        out.puts("    end")
      end

      out.puts("  end")
      out.puts

      out.puts("  include Actions")
      out.puts("end")
    end

    def print_bison(out=$stdout)
      tokens.each_with_index do |token, i|
        out.puts("%token #{token} #{300+i}")
      end

      out.puts
      out.puts("%define api.pure true")
      out.puts("%define parse.error verbose")
      out.puts("%parse-param { VALUE __parser }")
      out.puts("%lex-param { VALUE __parser }")
      out.puts("%locations")
      out.puts

      out.puts("%{")
      out.puts("#include <ruby.h>")
      out.puts("#define YYSTYPE VALUE")
      out.puts("%}")
      out.puts

      out.puts("%code provides {")
      out.puts("static int yylex(YYSTYPE *, YYLTYPE *, VALUE);")
      out.puts("static void yyerror(YYLTYPE *, VALUE, const char *);")
      out.puts("}")

      out.puts("%%")
      out.puts

      rules.each do |rule|
        out.puts("#{rule.name}:")
        rule.components.each_with_index do |seq, i|
          out.puts("|") unless i.zero?
          seq.each do |e|
            case e
            when Bison::Nonterminal
              out.print("  #{e.name}")
            end
          end
          out.puts
          if seq.action
            method = "rb_intern(#{seq.action_name.inspect})"
            args = seq.tags.keys.map{ |i| "$#{i}" }.join(', ')
            args = args.empty? ? '0' : "#{seq.tags.size}, #{args}"
            out.puts("  { $$ = rb_funcall(__parser, #{method}, #{args}); }")
            out.puts
          end
        end
        out.puts(";")
        out.puts
      end

      out.puts('%%')
      out.puts

      out.puts <<-EOF
static VALUE c#{name};

static VALUE #{uname}_parse(VALUE);

void Init_#{uname}(void) {
  c#{name} = rb_const_get(rb_cObject, rb_intern("#{name}"));
  rb_define_method(c#{name}, "parse", #{uname}_parse, 0);
}

VALUE #{uname}_parse(VALUE self) {
  return yyparse(self) ? Qnil : self;
}

static void yyerror(YYLTYPE *loc, VALUE parser, const char *msg) {
  rb_funcall(parser, rb_intern("error"), 3,
             rb_str_new_cstr(msg), 
             INT2FIX(loc->first_line), 
             INT2FIX(loc->first_column));
}

static int yylex(YYSTYPE *lval, YYLTYPE *lloc, VALUE parser) {
  VALUE value, vtok, vrow, vcol;

  lloc->first_line = lloc->last_line;
  lloc->first_column = lloc->last_column;

  vtok = rb_funcall(parser, rb_intern("lex"), 0);
  vrow = rb_funcall(parser, rb_intern("row"), 0);
  vcol = rb_funcall(parser, rb_intern("col"), 0);
  value = rb_funcall(parser, rb_intern("lex_value"), 0);

  lloc->last_line = FIX2INT(vrow);
  lloc->last_column = FIX2INT(vcol);

  if (vtok == Qnil) {
    *lval = Qnil;
    return 0;
  }
  
  *lval = value;

  return FIX2INT(vtok);
}
      EOF
    end

    def print_extconf(out=$stdout)
      out.puts("require 'mkmf'")
      out.puts

      out.puts("create_makefile '#{uname}/#{uname}'")
    end
    
    def uname
      name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end
  end
end
