
#include <errno.h>

#include "ruby.h"

#include "grammar.h"

VALUE bison_file_parse(VALUE);

static VALUE cBison;
static VALUE cBisonFile;
static VALUE cBisonProduction;
static VALUE cBisonNonterminal;

void Init_bison(void) {
  cBison = rb_const_get(rb_cObject, rb_intern("Bison"));
  cBisonFile = rb_const_get(cBison, rb_intern("File"));
  cBisonProduction = rb_const_get(cBison, rb_intern("Production"));
  cBisonNonterminal = rb_const_get(cBison, rb_intern("Nonterminal"));

  rb_define_method(cBisonFile, "parse", bison_file_parse, 0);
}

VALUE bison_file_parse(VALUE self) {
  BisonFile parser;
  char *filepath;
  VALUE path = rb_funcall(self, rb_intern("path"), 0);

  if (!RTEST(path))
    rb_raise(rb_eRuntimeError, "Bison file has no @path");

  filepath = StringValueCStr(path);
  parser.handle = fopen(filepath, "r");
  if (parser.handle == NULL)
    rb_raise(rb_eRuntimeError, "Error opening file: %s", strerror(errno));

  parser.rb_object = self;
  parser.rb_production = cBisonProduction;
  parser.rb_nonterminal = cBisonNonterminal;

  return yyparse(&parser) ? Qnil : Qtrue;
}
