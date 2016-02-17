require 'mkmf'
require 'shellwords'

output = "#{File.dirname(__FILE__)}/bison_parser.c"
bison_file = "#{File.dirname(__FILE__)}/bison_parser.y"

bison = find_executable(ENV['BISON_PATH'] || 'bison')
bison_version = `#{Shellwords.shellescape(bison)} --version`.lines[0]
if bison_version =~ / [012]\.\d+(\.\d+)?\b/
  abort("bison version must be >= 3.0.0")
end
system(bison, '-o', output, bison_file) or abort("bison command failed")

create_makefile 'bison_parser/bison_parser'
