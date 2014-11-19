class BisonParser
  class Actions
    attr_accessor :parser, :result

    def _9567eabe8731ddffc930dfa47ba32e2d(tokens, rules, code)
      self.result = Bison::GrammarFile.new(tokens, rules, code)
    end

    def _3e56cd0676452cbd6b35cad018c8bd53()
      nil
    end

    def _768f1d31b04599f62ec923463f1e2b6f(actions)
      actions
    end

    def _ab0d94dd8362e7e1934794bde7b3b63c()
      []
    end

    def _11c40bda6346f9634f8e351c6d2ef8a1(list, name)
      list << name
    end

    def _ab0d94dd8362e7e1934794bde7b3b63c()
      []
    end

    def _75f72aa78da3a939a875eeee6a83ac74(list, rule)
      list << rule
    end

    def _4a41473bfd1b570b004d337eb6f31aa9(name, components)
      Bison::Rule.new(name, components)
    end

    def _ab0d94dd8362e7e1934794bde7b3b63c()
      []
    end

    def _9dabfe7ebee5aeaf84d6b5447c719d0e(component)
      [component]
    end

    def _6dcbbf21ac55c82874061429b5340726(sequence, component)
      sequence << component
    end

    def _b8e629395574e33fa8fe4f175c10a466(sequence, action)
      sequence.tap do |s|; s.action = action; end
    end

    def _0521efb11c89cb982ac644a783948f3f()
      Bison::Sequence.new
    end

    def _09d42eb57efb1183f13b22f0a20a761d(sequence, follower)
      sequence << Bison::Nonterminal.new(follower)
    end

    def _4194bb95808462eab11e86379b0ac20a(sequence, follower, tag)
      sequence << Bison::Nonterminal.new(follower, tag)
    end
  end
end
