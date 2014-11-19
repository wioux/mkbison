
require 'erb'

module Bison
  class GrammarFile
    attr_accessor :name
    attr_reader :tokens, :rules, :code

    def initialize(tokens, rules, code)
      @tokens, @rules, @code = tokens, rules, code
    end

    def print_class(out=$stdout)
      template = File.expand_path('../../../templates/class.rb.erb', __FILE__)
      out.puts(ERB.new(File.read(template), nil, '-').result(binding))
    end

    def print_base_module(out=$stdout)
      template = File.expand_path('../../../templates/base.rb.erb', __FILE__)
      out.puts(ERB.new(File.read(template), nil, '-').result(binding))
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
      template = File.expand_path('../../../templates/extconf.rb.erb', __FILE__)
      out.puts(ERB.new(File.read(template), nil, '-').result(binding))
    end
    
    def uname
      name.gsub(/([a-z])([A-Z])/, '\1_\2').downcase
    end
  end
end
