class Hashr
  module Helpers
    private

      def normalize(data, definition, defaults)
        data = data.deep_symbolize_keys
        data = defaults.deep_merge(data).deep_symbolize_keys
        definition.deep_merge(data).deep_symbolize_keys
      end

      def decorate(hash)
        hash.each do |key, value|
          if key == :_include
            include_modules(value)
          elsif key == :_delegate
            include_delegators(value)
          elsif key == :_access
            include_accessors(value)
          end
        end
        hash.reject { |key, value| %i(_include _access _delegate).include?(key) }
      end

      def deep_hashrize(hash, defaults)
        hash.inject({}) do |result, (key, value)|
          result[key] = hashrize(value, defaults)
          result
        end
      end

      def hashrize(value, defaults)
        case value
        when Array
          value.map { |element| hashrize(element, defaults) }
        when Hash
          Hashr.new(value, nil, defaults)
        else
          value
        end
      end

      def include_modules(modules)
        Array(modules).each { |mod| meta_class.send(:include, mod) } if modules
      end

      def include_delegators(delegators)
        Array(delegators).each { |delegator| meta_class.send(:define_method, delegator) { data.send(delegator) } } if delegators
      end

      def include_accessors(accessors)
        # TODO deprecate
        Array(accessors).each { |accessor| meta_class.send(:define_method, accessor) { data[accessor] } } if accessors
      end

      def meta_class
        class << self; self end
      end
  end
end
