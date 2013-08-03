require 'hashr/core_ext/ruby/hash'
require 'hashr/helpers'

class Hashr
  class Data
    include Helpers, Enumerable

    attr_reader :data

    def initialize(data, definition, defaults)
      data = normalize(data, definition, defaults)
      data = decorate(data)
      @data =deep_hashrize(data, defaults)
    end

    def [](key)
      data.key?(key) || !Hashr.raise_missing_keys ? data[key.to_sym] : fetch(key)
    end

    def []=(key, value)
      store(key, value)
    end

    def fetch(key, default = nil)
      data.store(key.to_sym, Hashr.new(default)) if default && !key?(key)
      data.fetch(key.to_sym)
    end

    def store(key, value)
      data.store(key.to_sym, value.is_a?(Hash) ? Hashr.new(value, {}) : value)
    end

    def set(key, value)
      keys = key.to_s.split('.')
      if keys.size == 1
        store(key.to_sym, value)
      else
        store(keys.shift, Hashr.new).store(keys.join('.'), value)
      end
    end

    def count
      data.count # TODO deprecate
    end

    def each(&block)
      data.each(&block)
    end

    def to_hash
      data.inject({}) do |hash, (key, value)|
        hash[key] = value.is_a?(Hashr) ? value.to_hash : value
        hash
      end
    end

    def respond_to?(method)
      if Hashr.raise_missing_keys
        data.key?(method)
      else
        true
      end
    end

    def method_missing(method, *args, &block)
      case method.to_s[-1, 1]
      when '?'
        !!self[method.to_s[0..-2].to_sym]
      when '='
        self[method.to_s[0..-2].to_sym] = args.first
      else
        raise(KeyError.new("Key #{method.inspect} is not defined.")) if !data.key?(method) && Hashr.raise_missing_keys
        self[method]
      end
    end
  end
end
