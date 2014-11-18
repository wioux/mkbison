
%token IDENTIFIER	300
%token STRING		301
%token COLON		302
%token SEMICOLON	303
%token PIPE		304
%token HASH		305
%token DOUBLE_HASH	306
%token KW_TOKEN		307
%token ACTIONS		308

%define api.pure true
%define parse.error verbose
%parse-param { BisonFile *parser }
%lex-param { BisonFile *parser }
%locations

%{
#include "grammar.h"

#define YYSTYPE VALUE
%}

%code provides {
int yylex(YYSTYPE *, YYLTYPE *, BisonFile *);
void yyerror(YYLTYPE *, BisonFile *, const char *);
}

%%

grammar_file :
  token_list DOUBLE_HASH grammar_rules optional_code;

optional_code :
  /* empty */
|
  DOUBLE_HASH ACTIONS;

token_list :
  /* empty */
|
  token_list
  HASH KW_TOKEN IDENTIFIER
  {
    rb_funcall(parser->rb_object, rb_intern("create_token"), 1, $4);
  }
;

grammar_rules:
  /* empty */
|
  grammar_rules grammar_rule
;

grammar_rule:
  IDENTIFIER COLON components SEMICOLON
  {
    $$ = Qnil;
    rb_funcall(parser->rb_object, rb_intern("create_rule"), 2, $1, $3);
  }
;

components:
  /* empty */
  {
    $$ = rb_ary_new();
  }
| component
  {
    $$ = rb_ary_new();
    rb_funcall($$, rb_intern("push"), 1, $1);
  }
|
  components PIPE component
  {
    $$ = $1;
    rb_funcall($1, rb_intern("push"), 1, $3);
  }
;


component:
  production
|
  production ACTIONS
  {
    $$ = $1;
    rb_funcall($$, rb_intern("action="), 1, $2);
  }
;

production:
  /* empty */
  {
    $$ = rb_funcall(parser->rb_production, rb_intern("new"), 0);
  }
|
  production IDENTIFIER
  {
    $$ = $1;
    $2 = rb_funcall(parser->rb_nonterminal, rb_intern("new"), 1, $2);
    rb_funcall($1, rb_intern("push"), 1, $2);
  }
|
  production IDENTIFIER COLON IDENTIFIER
  {
    $$ = $1;
    $2 = rb_funcall(parser->rb_nonterminal, rb_intern("new"), 2, $4, $2);
    rb_funcall($1, rb_intern("push"), 1, $2);
  }
|
  production STRING
  {
    $$ = $1;
    rb_funcall($1, rb_intern("push"), 1, $2);
  }
;

%%

void yyerror(YYLTYPE *loc, BisonFile *parser, const char *msg) {
  fprintf(stderr, "(%d, %d):\t%s\n", loc->first_line, loc->first_column, msg);
}

#define DEBUG_TOKENS \
  (getenv("DEBUG_TOKENS") != NULL && getenv("DEBUG_TOKENS")[0] == '1')

#define RETURN_TOKEN(x) do {						\
    if(DEBUG_TOKENS) printf("yielding token type " #x "\n");		\
    if(DEBUG_TOKENS) printf("\tstr='%s'\n", strvalue);                  \
    return (x);								\
  } while(0)


int yylex(YYSTYPE *lval, YYLTYPE *lloc, BisonFile *parser) {
  VALUE value, vtok, vrow, vcol;

  lloc->first_line = lloc->last_line;
  lloc->first_column = lloc->last_column;

  vtok = rb_funcall(parser->rb_object, rb_intern("lex"), 0);
  vrow = rb_funcall(parser->rb_object, rb_intern("row"), 0);
  vcol = rb_funcall(parser->rb_object, rb_intern("col"), 0);
  value = rb_funcall(parser->rb_object, rb_intern("lex_value"), 0);

  lloc->last_line = FIX2INT(vrow);
  lloc->last_column = FIX2INT(vcol);

  if (vtok == Qnil) {
    *lval = Qnil;
    return 0;
  }
  
  *lval = value;

  return FIX2INT(vtok);
}
