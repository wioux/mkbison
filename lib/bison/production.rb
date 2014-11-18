
require 'digest'

module Bison
  class Production
    attr_reader :sequence
    attr_accessor :action
    
    def initialize
      @sequence = []
    end

    def push(e)
      @sequence.push(e)
    end

    def tags
      tags = sequence.each_with_index.map do |e, i|
        [i+1, e.tag] if e.tag
      end.compact
      
      Hash[tags]
    end

    def action_name
      '_'+Digest::MD5.hexdigest(tags.inspect + action.inspect)
    end
  end
end
