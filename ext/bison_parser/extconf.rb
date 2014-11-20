require 'mkmf'

output = "#{File.dirname(__FILE__)}/bison_parser.c"
bison_file = "#{File.dirname(__FILE__)}/bison_parser.y"
system('bison', '-o', output, bison_file)

create_makefile 'bison_parser/bison_parser'
