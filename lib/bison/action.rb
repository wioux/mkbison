
require 'digest'
require 'tempfile'

module Bison
  class Action
    attr_accessor :code
    attr_accessor :location
    attr_accessor :predecessors
    attr_accessor :sequence

    def initialize(code)
      self.code = code
    end

    def to_bison
      code = "\n  {\n"
      code << %(    rb_ivar_set(__actions, rb_intern("@_"), rb_ary_new3(2, INT2FIX(@$.first_line), INT2FIX(@$.first_column)));\n)
      predecessor_tags.each do |i, name|
        code << %(    rb_ivar_set(__actions, rb_intern("@#{name}"), rb_ary_new3(2, INT2FIX(@#{i}.first_line), INT2FIX(@#{i}.first_column)));\n)
      end
      code << %(    $$ = #{funcall('__actions')};\n)
      code << "  }\n"
    end

    def predecessor_tags
      tags = predecessors.each_with_index.map do |e, i|
        [i+1, e.tag] if (Bison::Nonterminal === e) && e.tag
      end.compact
      
      Hash[tags]
    end

    def errors
      tmp = Tempfile.new('action-src.rb').tap do |tmp|
        location[0].times{ tmp.puts }
        tmp.puts(code)
        tmp.close
      end

      errors = `ruby -c "#{tmp.path}" 2>&1`
      if $?.success?
        return nil
      else
        return errors.gsub(tmp.path, '-')
      end
    end

    def name
      base = "_#{sequence.index}_#{sequence.rule.name}"
      base << "_#{Digest::MD5.hexdigest(predecessor_tags.inspect)}"
    end

    # What to do about default $1/Qnil?
    def funcall(receiver)
      method = "rb_intern(#{name.inspect})"
      args = predecessor_tags.keys.map{ |i| "$#{i}" }.join(', ')
      args = args.empty? ? '0' : "#{predecessor_tags.size}, #{args}"
      "rb_funcall(#{receiver}, #{method}, #{args})"
    end

  end
end
