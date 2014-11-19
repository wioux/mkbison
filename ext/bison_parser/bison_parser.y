

%token IDENTIFIER		300

%token STRING		301

%token COLON		302

%token SEMICOLON		303

%token LBRACK		304

%token RBRACK		305

%token PIPE		306

%token HASH		307

%token DOUBLE_HASH		308

%token KW_TOKEN		309

%token ACTIONS		310



%define api.pure true
%define parse.error verbose
%parse-param { VALUE __parser }
%lex-param { VALUE __parser }
%locations

%{
#include <ruby.h>
#define YYSTYPE VALUE
%}

%code provides {
static int yylex(YYSTYPE *, YYLTYPE *, VALUE);
static void yyerror(YYLTYPE *, VALUE, const char *);
}

%%

grammar_file:
  token_list DOUBLE_HASH grammar_rules optional_code
  { $$ = rb_funcall(__parser, rb_intern("_9567eabe8731ddffc930dfa47ba32e2d"), 3, $1, $3, $4); }
;

optional_code:

  { $$ = rb_funcall(__parser, rb_intern("_3e56cd0676452cbd6b35cad018c8bd53"), 0); }
|
  DOUBLE_HASH ACTIONS
  { $$ = rb_funcall(__parser, rb_intern("_768f1d31b04599f62ec923463f1e2b6f"), 1, $2); }
;

token_list:

  { $$ = rb_funcall(__parser, rb_intern("_ab0d94dd8362e7e1934794bde7b3b63c"), 0); }
|
  token_list HASH KW_TOKEN IDENTIFIER
  { $$ = rb_funcall(__parser, rb_intern("_11c40bda6346f9634f8e351c6d2ef8a1"), 2, $1, $4); }
;

grammar_rules:

  { $$ = rb_funcall(__parser, rb_intern("_ab0d94dd8362e7e1934794bde7b3b63c"), 0); }
|
  grammar_rules grammar_rule
  { $$ = rb_funcall(__parser, rb_intern("_75f72aa78da3a939a875eeee6a83ac74"), 2, $1, $2); }
;

grammar_rule:
  IDENTIFIER COLON components SEMICOLON
  { $$ = rb_funcall(__parser, rb_intern("_4a41473bfd1b570b004d337eb6f31aa9"), 2, $1, $3); }
;

components:

  { $$ = rb_funcall(__parser, rb_intern("_ab0d94dd8362e7e1934794bde7b3b63c"), 0); }
|
  component
  { $$ = rb_funcall(__parser, rb_intern("_9dabfe7ebee5aeaf84d6b5447c719d0e"), 1, $1); }
|
  components PIPE component
  { $$ = rb_funcall(__parser, rb_intern("_6dcbbf21ac55c82874061429b5340726"), 2, $1, $3); }
;

component:
  sequence
  { $$ = $1; }
|
  sequence ACTIONS
  { $$ = rb_funcall(__parser, rb_intern("_b8e629395574e33fa8fe4f175c10a466"), 2, $1, $2); }
;

sequence:

  { $$ = rb_funcall(__parser, rb_intern("_0521efb11c89cb982ac644a783948f3f"), 0); }
|
  sequence IDENTIFIER
  { $$ = rb_funcall(__parser, rb_intern("_09d42eb57efb1183f13b22f0a20a761d"), 2, $1, $2); }
|
  sequence IDENTIFIER LBRACK IDENTIFIER RBRACK
  { $$ = rb_funcall(__parser, rb_intern("_4194bb95808462eab11e86379b0ac20a"), 3, $1, $2, $4); }
;


%%

static VALUE cBisonParser;
static VALUE cBisonParserTokens;

static VALUE bison_parser_parse(VALUE);

void Init_bison_parser(void) {
  cBisonParser = rb_define_class("BisonParser", rb_cObject);
  cBisonParserTokens = rb_define_module_under(cBisonParser, "Tokens");

  rb_define_const(cBisonParserTokens, "IDENTIFIER", INT2FIX(IDENTIFIER));
  rb_define_const(cBisonParserTokens, "STRING", INT2FIX(STRING));
  rb_define_const(cBisonParserTokens, "COLON", INT2FIX(COLON));
  rb_define_const(cBisonParserTokens, "SEMICOLON", INT2FIX(SEMICOLON));
  rb_define_const(cBisonParserTokens, "LBRACK", INT2FIX(LBRACK));
  rb_define_const(cBisonParserTokens, "RBRACK", INT2FIX(RBRACK));
  rb_define_const(cBisonParserTokens, "PIPE", INT2FIX(PIPE));
  rb_define_const(cBisonParserTokens, "HASH", INT2FIX(HASH));
  rb_define_const(cBisonParserTokens, "DOUBLE_HASH", INT2FIX(DOUBLE_HASH));
  rb_define_const(cBisonParserTokens, "KW_TOKEN", INT2FIX(KW_TOKEN));
  rb_define_const(cBisonParserTokens, "ACTIONS", INT2FIX(ACTIONS));

  rb_define_method(cBisonParser, "parse", bison_parser_parse, 0);
}

VALUE bison_parser_parse(VALUE self) {
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
