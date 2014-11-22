
require 'erb'

module Bison
  class GrammarFile
    attr_accessor :name
    attr_reader :tokens, :rules, :code

    def initialize(tokens, rules, code)
      @tokens, @rules, @code = tokens, rules, code
    end

    def validate
      errors = []
      symbols = tokens.map(&:name) + rules.map(&:name)
      rules.map(&:components).flatten.map(&:elements).flatten.each do |el|
        unless !(Bison::Nonterminal === el) || symbols.include?(el.name)
          errors << "#{el.location.join('.')}: #{el.name} is not defined"
        end
      end
      rules.map(&:components).flatten.each do |seq|
        seq.elements.grep(Bison::Action).each do |action|
          err = action.errors
          errors << err unless err.nil?
        end
      end
      abort(errors.join("\n")) unless errors.empty?
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
