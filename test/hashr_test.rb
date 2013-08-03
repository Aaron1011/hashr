require 'test_helper'

class HashrTest < Test::Unit::TestCase
  def teardown
    Hashr.raise_missing_keys = false
  end

  test 'initialize takes nil' do
    assert_nothing_raised { Hashr.new(nil) }
  end

  test 'to_hash converts the Hashr instance and all of its children to Hashes' do
    hash = Hashr.new(foo: { bar: { baz: 'baz' } }).to_hash

    assert hash.instance_of?(Hash)
    assert hash[:foo].instance_of?(Hash)
    assert hash[:foo][:bar].instance_of?(Hash)
  end

  test 'anonymously defining methods' do
    hashr = Hashr.new(count: 5) do
      def count
        self[:count]
      end
    end
    assert_equal 5, hashr.count
  end
end
