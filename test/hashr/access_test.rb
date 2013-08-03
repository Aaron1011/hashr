require 'test_helper'

class HashrAccessTest < Test::Unit::TestCase
  def teardown
    Hashr.raise_missing_keys = false
  end

  # hash access

  test 'hash access to an existing key returns the value' do
    assert_equal 'foo', Hashr.new(foo: 'foo')[:foo]
  end

  test 'hash access to a non-existing key returns nil when raise_missing_keys is false' do
    Hashr.raise_missing_keys = false
    assert_nil Hashr.new(foo: 'foo')[:bar]
  end

  test 'hash access to a non-existing key raises a KeyError when raise_missing_keys is true' do
    Hashr.raise_missing_keys = true
    assert_raises(KeyError) { Hashr.new(foo: 'foo')[:bar] }
  end

  test 'hash access is indifferent about symbols/strings (string data given, symbol keys used)' do
    assert_equal 'bar', Hashr.new('foo' => { 'bar' => 'bar' })[:foo][:bar]
  end

  test 'hash access is indifferent about symbols/strings (symbol data given, string keys used)' do
    assert_equal 'bar', Hashr.new(foo: { bar: 'bar' })['foo']['bar']
  end

  # method access

  test 'method access on an existing key returns the value' do
    assert_equal 'foo', Hashr.new(foo: 'foo').foo
  end

  test 'method access to a non-existing key returns nil when raise_missing_keys is false' do
    Hashr.raise_missing_keys = false
    assert_nil Hashr.new(foo: 'foo').bar
  end

  test 'method access to a non-existing key raises a KeyError when raise_missing_keys is true' do
    Hashr.raise_missing_keys = true
    assert_raises(KeyError) { Hashr.new(foo: 'foo').bar }
  end

  test 'method access on an existing nested key returns the value' do
    assert_equal 'bar', Hashr.new(foo: { bar: 'bar' }).foo.bar
  end

  test 'method access on a non-existing nested key returns nil when raise_missing_keys is false' do
    Hashr.raise_missing_keys = false
    assert_nil Hashr.new(foo: { bar: 'bar' }).foo.baz
  end

  test 'method access on a non-existing nested key raises an IndexError when raise_missing_keys is true' do
    Hashr.raise_missing_keys = true
    assert_raises(KeyError) { Hashr.new(foo: { bar: 'bar' }).foo.baz }
  end

  # predicates

  test 'method predicate mark returns true if the key has a value' do
    assert_equal true, Hashr.new(foo: { bar: 'bar' }).foo.bar?
  end

  test 'method predicate returns false if the key does not have a value' do
    assert_equal false, Hashr.new(foo: { bar: 'bar' }).foo.baz?
  end

  # assignment

  test 'hash assignment using a string key works' do
    hashr = Hashr.new
    hashr['foo'] = 'foo'
    assert_equal 'foo', hashr.foo
  end

  test 'hash assignment using a symbol key works' do
    hashr = Hashr.new
    hashr[:foo] = 'foo'
    assert_equal 'foo', hashr.foo
  end

  test 'method assignment works' do
    hashr = Hashr.new
    hashr.foo = 'foo'
    assert_equal 'foo', hashr.foo
  end

  # set

  test 'set with a dot separated path sets to nested hashes' do
    hashr = Hashr.new(foo: { bar: 'bar' })
    hashr.set('foo.baz', 'baz')
    assert_equal 'baz', hashr.foo.baz
  end

  # respond_to?

  test 'respond_to? returns true if raise_missing_keys is off' do
    Hashr.raise_missing_keys = false
    hashr = Hashr.new
    assert hashr.respond_to?(:foo)
  end

  test 'respond_to? returns false for missing keys if raise_missing_keys is on' do
    Hashr.raise_missing_keys = true
    hashr = Hashr.new
    assert_equal false, hashr.respond_to?(:foo)
  end

  test 'respond_to? returns true for extant keys if raise_missing_keys is on' do
    Hashr.raise_missing_keys = true
    hashr = Hashr.new
    hashr[:foo] = 'bar'
    assert hashr.respond_to?(:foo)
  end

end
