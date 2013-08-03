require 'test_helper'

class HashrEnumerableTest < Test::Unit::TestCase
  test 'each works' do
    data = { foo: 'foo' }
    result = {}
    Hashr.new(foo: 'foo').each { |key, value| result[key] = value }
    assert_equal data, result
  end

  test 'map works' do
    result = Hashr.new(foo: 'foo').map { |key, value| [key, value] }
    assert_equal [[:foo, 'foo']], result
  end

  test 'select works' do
    result = Hashr.new(foo: 'foo', bar: 'bar').select { |key, value| key == :foo }
    assert_equal [[:foo, 'foo']], result
  end
end
