require 'hashr/core_ext/ruby/hash'

class Hashr
  require 'hashr/data'
  require 'hashr/env_defaults'
  require 'hashr/helpers'

  class << self
    include Helpers

    attr_accessor :raise_missing_keys

    def define(definition)
      @definition = self.definition.merge(definition)
    end

    def definition
      @definition ||= {}
    end

    def default(defaults)
      @defaults = defaults
    end

    def defaults
      @defaults ||= {}
    end
  end

  undef :id if method_defined?(:id) # undefine deprecated method #id on 1.8.x

  attr_reader :_data

  def initialize(data = nil, definition = nil, defaults = nil, &block)
    @_data = Data.new(data || {}, definition || self.class.definition, defaults || self.class.defaults)
    (class << self; self; end).class_eval(&block) if block
  end

  def respond_to?(method)
    _data.respond_to?(method)
  end

  def method_missing(*args, &block)
    _data.send(*args, &block)
  end
end

