
require 'digest'

module Bison
  class Sequence
    attr_reader :elements
    attr_accessor :action
    
    def initialize
      @elements = []
    end

    def <<(element)
      elements << element
      self
    end

    def tags
      tags = elements.each_with_index.map do |e, i|
        [i+1, e.tag] if e.tag
      end.compact
      
      Hash[tags]
    end

    def action_name
      '_'+Digest::MD5.hexdigest(tags.inspect + action.inspect)
    end

  end
end
