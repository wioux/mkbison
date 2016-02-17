class BisonParser
  class Actions
    attr_accessor :parser, :result

    def _0_grammar_file_a94c71c90dcf6de40d17336b9d39db58(tokens, rules, code)
      self.result = Bison::GrammarFile.new(tokens, rules, code)
    end

    def _0_optional_code_99914b932bd37a50b983c5e7c90ae93b()
      nil
    end

    def _1_optional_code_1359d45d91e668b6af09d4ac3c336a88(actions)
      actions
    end

    def _0_token_list_99914b932bd37a50b983c5e7c90ae93b()
      []
    end

    def _1_token_list_21a28d2acdd128c24843b772a9881f2d(list, token)
      list << token
    end

    def _0_token_f014c38ad08ecac5d62c0e3fa23163b3(name)
      Bison::Token.new(name)
    end

    def _2_token_445055bddb5840e621fa399faa56aefc(token, num)
      token.tap{ |t| t.number = num }
    end

    def _0_assoc_token_f014c38ad08ecac5d62c0e3fa23163b3(name)
      Bison::Token.new(name, :left)
    end

    def _1_assoc_token_f014c38ad08ecac5d62c0e3fa23163b3(name)
      Bison::Token.new(name, :right)
    end

    def _2_assoc_token_1d82357deb6789321b86aa67cf1f1cf6(token, name)
      token.tap{ |t| t.names << name }
    end

    def _0_grammar_rules_99914b932bd37a50b983c5e7c90ae93b()
      []
    end

    def _1_grammar_rules_d4b402a4ddf06c5292ab917a96fe105c(list, rule)
      list << rule
    end

    def _0_grammar_rule_bce7f6337f3284ba4a3537cc1d642c28(name, components)
      Bison::Rule.new(name, components).tap{ |r| r.location = @name }
    end

    def _0_components_2403a823f1a9854a29da7cf64f191fbe(sequence)
      [sequence]
    end

    def _1_components_62da044340939f02b6c0b52917617e17(sequences, sequence)
      sequences << sequence
    end

    def _0_sequence_99914b932bd37a50b983c5e7c90ae93b()
      Bison::Sequence.new
    end

    def _1_sequence_512ceffccf6bb7565046f90d6d7762ad(sequence, code)
      sequence << Bison::Action.new(code).tap{ |a| a.location = @code }
    end

    def _2_sequence_4b2903c3aeb37d22d413a53653d0df28(sequence, follower)
      sequence << Bison::Nonterminal.new(follower).tap{ |x| x.location = @follower }
    end

    def _3_sequence_68f2380aa0f3a7de0fb9b3482705a54c(sequence, follower, tag)
      sequence << Bison::Nonterminal.new(follower, tag).tap{ |x| x.location = @follower }
    end
  end
end
