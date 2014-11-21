
require 'digest'
require 'tempfile'

module Bison
  class Sequence
    attr_accessor :rule, :index
    attr_reader :elements
    attr_accessor :action
    attr_accessor :action_location
    
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

    def action_errors
      return nil unless action

      tmp = Tempfile.new('action-src.rb').tap do |tmp|
        action_location[0].times{ tmp.puts }
        tmp.puts(action)
        tmp.close
      end

      errors = `ruby -c "#{tmp.path}" 2>&1`
      if $?.success?
        return nil
      else
        return errors.gsub(tmp.path, '-')
      end
    end

    def action_name
      "_#{index}_#{rule.name}_#{Digest::MD5.hexdigest(tags.inspect)}"
    end

    def action_funcall(receiver)
      if action
        method = "rb_intern(#{action_name.inspect})"
        args = tags.keys.map{ |i| "$#{i}" }.join(', ')
        args = args.empty? ? '0' : "#{tags.size}, #{args}"
        "rb_funcall(#{receiver}, #{method}, #{args})"
      elsif elements.size != 0
        '$1'
      else
        'Qnil'
      end
    end

  end
end
