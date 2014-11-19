
require 'erb'

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
      out.puts("  attr_reader :io")
      out.puts("  attr_accessor :lex_value, :result, :row, :col")
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

    def print_actions_module(out=$stdout)
      template = File.expand_path('../../../templates/actions.rb.erb', __FILE__)
      out.puts(ERB.new(File.read(template), nil, '-').result(binding))
    end

    def print_bison(out=$stdout)
      template = File.expand_path('../../../templates/parser.y.erb', __FILE__)
      out.puts(ERB.new(File.read(template), nil, '-').result(binding))
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
