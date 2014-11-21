
%token	IDENTIFIER			300
%token	STRING				301
%token	COLON				302
%token	SEMICOLON			303
%token	LBRACK				304
%token	RBRACK				305
%token	PIPE				306
%token	HASH				307
%token	DOUBLE_HASH			308
%token	KW_TOKEN			309
%token	KW_LEFT				310
%token	KW_RIGHT			311
%token	ACTIONS				312


%define api.pure true
%define parse.error verbose
%parse-param { VALUE __actions }
%lex-param { VALUE __actions }
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
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@tokens"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@rules"), rb_ary_new3(2, INT2FIX(@3.first_line), INT2FIX(@3.first_column)));
    rb_ivar_set(__actions, rb_intern("@code"), rb_ary_new3(2, INT2FIX(@4.first_line), INT2FIX(@4.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_grammar_file_a94c71c90dcf6de40d17336b9d39db58"), 3, $1, $3, $4);
  }
;

optional_code:

  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_optional_code_99914b932bd37a50b983c5e7c90ae93b"), 0);
  }
|
  DOUBLE_HASH ACTIONS
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@actions"), rb_ary_new3(2, INT2FIX(@2.first_line), INT2FIX(@2.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_optional_code_1359d45d91e668b6af09d4ac3c336a88"), 1, $2);
  }
;

token_list:

  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_token_list_99914b932bd37a50b983c5e7c90ae93b"), 0);
  }
|
  token_list token
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@list"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@token"), rb_ary_new3(2, INT2FIX(@2.first_line), INT2FIX(@2.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_token_list_21a28d2acdd128c24843b772a9881f2d"), 2, $1, $2);
  }
;

token:
  HASH KW_TOKEN IDENTIFIER
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@name"), rb_ary_new3(2, INT2FIX(@3.first_line), INT2FIX(@3.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_token_f014c38ad08ecac5d62c0e3fa23163b3"), 1, $3);
  }
|
  HASH KW_LEFT IDENTIFIER
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@name"), rb_ary_new3(2, INT2FIX(@3.first_line), INT2FIX(@3.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_token_f014c38ad08ecac5d62c0e3fa23163b3"), 1, $3);
  }
|
  HASH KW_RIGHT IDENTIFIER
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@name"), rb_ary_new3(2, INT2FIX(@3.first_line), INT2FIX(@3.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_2_token_f014c38ad08ecac5d62c0e3fa23163b3"), 1, $3);
  }
;

grammar_rules:

  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_grammar_rules_99914b932bd37a50b983c5e7c90ae93b"), 0);
  }
|
  grammar_rules grammar_rule
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@list"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@rule"), rb_ary_new3(2, INT2FIX(@2.first_line), INT2FIX(@2.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_grammar_rules_d4b402a4ddf06c5292ab917a96fe105c"), 2, $1, $2);
  }
;

grammar_rule:
  IDENTIFIER COLON components SEMICOLON
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@name"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@components"), rb_ary_new3(2, INT2FIX(@3.first_line), INT2FIX(@3.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_grammar_rule_bce7f6337f3284ba4a3537cc1d642c28"), 2, $1, $3);
  }
;

components:

  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_components_99914b932bd37a50b983c5e7c90ae93b"), 0);
  }
|
  component
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@component"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_components_0c3a5ada7333900791423d7f17efa5e8"), 1, $1);
  }
|
  components PIPE component
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@sequence"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@component"), rb_ary_new3(2, INT2FIX(@3.first_line), INT2FIX(@3.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_2_components_337d420d17c37c9e4219b6a95f7561c0"), 2, $1, $3);
  }
;

component:
  sequence
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    $$ = $1;
  }
|
  sequence ACTIONS
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@sequence"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@action"), rb_ary_new3(2, INT2FIX(@2.first_line), INT2FIX(@2.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_component_802dc4bb99cad8bfa7c7bf22b7349862"), 2, $1, $2);
  }
;

sequence:

  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_0_sequence_99914b932bd37a50b983c5e7c90ae93b"), 0);
  }
|
  sequence IDENTIFIER
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@sequence"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@follower"), rb_ary_new3(2, INT2FIX(@2.first_line), INT2FIX(@2.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_1_sequence_4b2903c3aeb37d22d413a53653d0df28"), 2, $1, $2);
  }
|
  sequence IDENTIFIER LBRACK IDENTIFIER RBRACK
  {
    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));
    rb_ivar_set(__actions, rb_intern("@sequence"), rb_ary_new3(2, INT2FIX(@1.first_line), INT2FIX(@1.first_column)));
    rb_ivar_set(__actions, rb_intern("@follower"), rb_ary_new3(2, INT2FIX(@2.first_line), INT2FIX(@2.first_column)));
    rb_ivar_set(__actions, rb_intern("@tag"), rb_ary_new3(2, INT2FIX(@4.first_line), INT2FIX(@4.first_column)));
    $$ = rb_funcall(__actions, rb_intern("_2_sequence_68f2380aa0f3a7de0fb9b3482705a54c"), 3, $1, $2, $4);
  }
;


%%

static VALUE cBisonParser;
static VALUE cBisonParserTokens;
static VALUE cBisonParserActions;

static VALUE bison_parser_parse(VALUE);

void Init_bison_parser(void) {
  cBisonParser = rb_define_class("BisonParser", rb_cObject);
  cBisonParserTokens = rb_define_module_under(cBisonParser, "Tokens");
  cBisonParserActions = rb_define_class_under(cBisonParser, "Actions", rb_cObject);

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
  rb_define_const(cBisonParserTokens, "KW_LEFT", INT2FIX(KW_LEFT));
  rb_define_const(cBisonParserTokens, "KW_RIGHT", INT2FIX(KW_RIGHT));
  rb_define_const(cBisonParserTokens, "ACTIONS", INT2FIX(ACTIONS));

  rb_define_method(cBisonParser, "parse", bison_parser_parse, 0);
}

VALUE bison_parser_parse(VALUE self) {
  VALUE actions = rb_funcall(cBisonParserActions, rb_intern("new"), 0);
  rb_funcall(actions, rb_intern("parser="), 1, self);
  if (yyparse(actions))
    return Qnil;
  return rb_funcall(actions, rb_intern("result"), 0);
}

static void yyerror(YYLTYPE *loc, VALUE actions, const char *msg) {
  VALUE parser = rb_funcall(actions, rb_intern("parser"), 0);
  rb_funcall(parser, rb_intern("error"), 3,
             rb_str_new_cstr(msg), 
             INT2FIX(loc->first_line), 
             INT2FIX(loc->first_column));
}

static int yylex(YYSTYPE *lval, YYLTYPE *lloc, VALUE actions) {
  VALUE parser, value, vtok;

  parser = rb_funcall(actions, rb_intern("parser"), 0);

  rb_funcall(parser, rb_intern("token_row="), 1, INT2FIX(lloc->last_line));
  rb_funcall(parser, rb_intern("token_col="), 1, INT2FIX(lloc->last_column));

  vtok = rb_funcall(parser, rb_intern("lex"), 0);
  value = rb_funcall(parser, rb_intern("lex_value"), 0);

  lloc->first_line = FIX2INT(rb_funcall(parser, rb_intern("token_row"), 0));
  lloc->first_column = FIX2INT(rb_funcall(parser, rb_intern("token_col"), 0));
  lloc->last_line = FIX2INT(rb_funcall(parser, rb_intern("row"), 0));
  lloc->last_column = FIX2INT(rb_funcall(parser, rb_intern("col"), 0));

  if (vtok == Qnil) {
    *lval = Qnil;
    return 0;
  }
  
  *lval = value;

  return FIX2INT(vtok);
}
