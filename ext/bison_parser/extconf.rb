require 'mkmf'

output = "#{File.dirname(__FILE__)}/bison_parser.c"
bison_file = "#{File.dirname(__FILE__)}/bison_parser.y"

bison = find_executable(ENV['BISON_PATH'] || 'bison')
system(bison, '-o', output, bison_file) or abort("bison command failed")

create_makefile 'bison_parser/bison_parser'
