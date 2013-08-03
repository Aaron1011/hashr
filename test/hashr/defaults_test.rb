require 'test_helper'

class HashrDefaultsTest < Test::Unit::TestCase
  test 'defining defaults' do
    klass = Class.new(Hashr) do
      define foo: 'foo', bar: { baz: 'baz' }
    end

    assert_equal 'foo', klass.new.foo
    assert_equal 'baz', klass.new.bar.baz
  end

  test 'defining defaults several times merges definitions' do
    klass = Class.new(Hashr) do
      define foo: 'foo'
      define bar: { baz: 'baz' }
    end

    assert_equal 'foo', klass.new.foo
    assert_equal 'baz', klass.new.bar.baz
  end

  test 'defining different defaults on different classes ' do
    foo = Class.new(Hashr) { define foo: 'foo' }
    bar = Class.new(Hashr) { define bar: 'bar' }

    assert_equal 'foo', foo.definition[:foo]
    assert_equal 'bar', bar.definition[:bar]
  end

  test 'mixing symbol and string keys in defaults and data' do
    Symbolized  = Class.new(Hashr) { define foo: 'foo' }
    Stringified = Class.new(Hashr) { define 'foo' => 'foo' }
    NoDefault   = Class.new(Hashr)

    assert_equal 'foo', Symbolized.new.foo
    assert_equal 'foo', Stringified.new.foo
    assert_nil NoDefault.new.foo

    assert_equal 'foo', Symbolized.new(foo: 'foo').foo
    assert_equal 'foo', Stringified.new(foo: 'foo').foo
    assert_equal 'foo', NoDefault.new(foo: 'foo').foo

    assert_equal 'foo', Symbolized.new('foo' => 'foo').foo
    assert_equal 'foo', Stringified.new('foo' => 'foo').foo
    assert_equal 'foo', NoDefault.new('foo' => 'foo').foo
  end
end
