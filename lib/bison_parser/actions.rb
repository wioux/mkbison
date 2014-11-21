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

    def _1_token_f014c38ad08ecac5d62c0e3fa23163b3(name)
      Bison::Token.new(name, :left)
    end

    def _2_token_f014c38ad08ecac5d62c0e3fa23163b3(name)
      Bison::Token.new(name, :right)
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

    def _0_components_99914b932bd37a50b983c5e7c90ae93b()
      []
    end

    def _1_components_0c3a5ada7333900791423d7f17efa5e8(component)
      [component]
    end

    def _2_components_337d420d17c37c9e4219b6a95f7561c0(sequence, component)
      sequence << component
    end

    def _1_component_802dc4bb99cad8bfa7c7bf22b7349862(sequence, action)
      sequence.tap{ |s| s.action = action }
    end

    def _0_sequence_99914b932bd37a50b983c5e7c90ae93b()
      Bison::Sequence.new
    end

    def _1_sequence_4b2903c3aeb37d22d413a53653d0df28(sequence, follower)
      sequence << Bison::Nonterminal.new(follower).tap{ |x| x.location = @follower }
    end

    def _2_sequence_68f2380aa0f3a7de0fb9b3482705a54c(sequence, follower, tag)
      sequence << Bison::Nonterminal.new(follower, tag).tap{ |x| x.location = @follower }
    end
  end
end
