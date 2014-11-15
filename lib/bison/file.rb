module Bison
  class File
    attr_reader :path, :tokens, :rules

    def initialize(path)
      @path = path
      @rules = {}
      @tokens = []
    end

    def create_rule(name, components)
      rules[name] = components
    end

    def create_token(name)
      tokens << name
    end

    def print(out=$stdout)
      tokens.each do |token|
        out.puts("%token #{token}")
      end

      out.puts
      out.puts("%define api.pure true")
      out.puts("%define parse.error verbose")
      out.puts("%parse-param { Parser *parser }")
      out.puts("%lex-param { Parser *parser }")
      out.puts("%locations")
      out.puts

      out.puts("%%")
      out.puts

      rules.each do |name, alternatives|
        out.puts("#{name}:")
        alternatives.each_with_index do |alt, i|
          out.puts("|") unless i.zero?
          alt.sequence.each do |e|
            case e
            when Bison::Nonterminal
              out.print("  #{e.name}")
            end
          end
          out.puts
        end
        out.puts(";")
        out.puts
      end
    end
  end
end
