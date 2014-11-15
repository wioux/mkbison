
#include <stdio.h>

#include "ruby.h"

typedef struct BisonFile BisonFile;

struct BisonFile {
  FILE *handle;
  VALUE rb_object;
  VALUE rb_production;
  VALUE rb_nonterminal;
};

int yyparse(BisonFile *);
