
%token IDENTIFIER
%token STRING
%token COLON
%token SEMICOLON
%token PIPE
%token LCURLY
%token RCURLY
%token HASH
%token DOUBLE_HASH
%token KW_TOKEN
%token ACTIONS

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
  token_list DOUBLE_HASH grammar_rules;

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
  production action
  {
    $$ = $1;
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
  production STRING
  {
    $$ = $1;
    rb_funcall($1, rb_intern("push"), 1, $2);
  }

;

action:
  LCURLY ACTIONS RCURLY
;

%%

#include <ctype.h>

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
  int i, c, n, peak;
  char strvalue[128] = {0};
  char strpeak[sizeof("token")] = {0};
  FILE *input = parser->handle;

  *lval = Qnil;

 skip_space:
  while ((c = fgetc(input)) == ' ' || c == '\t')
    ++lloc->last_column;

  if (c == '#')
    while ((c = fgetc(input)) != EOF && c != '\n')
      ++lloc->last_column;

  if (c == EOF)
    RETURN_TOKEN(0);

  if (c == '\n') {
    ++lloc->last_line;
    lloc->last_column = 0;
    goto skip_space;
  }

  /* space is skipped */

  lloc->first_line = lloc->last_line;
  lloc->first_column = lloc->last_column;
  peak = fgetc(input);
  ungetc(peak, input);

  switch(c) {
  case ':':
    RETURN_TOKEN(COLON);
  case ';':
    RETURN_TOKEN(SEMICOLON);
  case '|':
    RETURN_TOKEN(PIPE);
  case '{':
    RETURN_TOKEN(LCURLY);
  case '}':
    RETURN_TOKEN(RCURLY);
  case '%':
    if (peak == '%') {
      fgetc(input);
      RETURN_TOKEN(DOUBLE_HASH);
    }
    RETURN_TOKEN(HASH);
  }

  if (isalpha(c)) {
    // TODO: length check
    strvalue[i = 0] = c;
    while (isalpha(c = fgetc(input)))
      strvalue[++i] = c;
    ungetc(c, input);

    if (!strcmp(strvalue, "token"))
      RETURN_TOKEN(KW_TOKEN);

    *lval = rb_str_new2(strvalue);
    RETURN_TOKEN(IDENTIFIER);
  }

  RETURN_TOKEN(0);
}
