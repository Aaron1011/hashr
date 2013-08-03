require 'test_helper'

class HashrSpecialTest < Test::Unit::TestCase
  test 'a key :_include includes the given modules' do
    modul = Module.new { def helper; 'helper'; end }
    klass = Class.new(Hashr) { define foo: { _include: modul } }
    assert_equal 'helper', klass.new(foo: { helper: 'foo' }).foo.helper
  end

  test 'a key :_include includes the given modules (using defaults)' do
    klass = Class.new(Hashr) do
      define foo: { _include: Module.new { def helper; 'helper'; end } }
    end
    assert_equal 'helper', klass.new.foo.helper
  end

  test 'a key :_include on defaults includes the modoules for all nested hashes' do
    modul = Module.new { def helper; 'helper'; end }
    klass = Class.new(Hashr) { default _include: modul }
    hashr = klass.new(foo: { bar: { baz: {} } })

    assert_equal 'helper', hashr.helper
    assert_equal 'helper', hashr.foo.helper
    assert_equal 'helper', hashr.foo.bar.helper
    assert_equal 'helper', hashr.foo.bar.baz.helper
  end

  test 'a key :_delegate includes an anonymous module with methods that delegate to the raw data hash' do
    klass = Class.new(Hashr) do
      define foo: { _delegate: [:count] }
    end
    assert_equal 1, klass.new(foo: { count: 5 }).foo.count
  end

  test 'a key :_access includes an anonymous module with accessors (deprecated)' do
    klass = Class.new(Hashr) do
      define foo: { _access: [:count] }
    end
    assert_equal 5, klass.new(foo: { count: 5 }).foo.count
  end

  test 'a key :_access on defaults allows access for all nested hashes (deprecated)' do
    modul = Module.new { def helper; 'helper'; end }
    klass = Class.new(Hashr) { default _access: :count }
    hashr = klass.new(count: 5, foo: { count: 5, bar: { count: 5, baz: { count: 5 } } })

    assert_equal 5, hashr.count
    assert_equal 5, hashr.foo.count
    assert_equal 5, hashr.foo.bar.count
    assert_equal 5, hashr.foo.bar.baz.count
  end

  test 'defining different env_namespaces on different classes' do
    foo = Class.new(Hashr) {extend Hashr::EnvDefaults; self.env_namespace = 'foo' }
    bar = Class.new(Hashr) {extend Hashr::EnvDefaults; self.env_namespace = 'bar' }

    assert_equal ['FOO'], foo.env_namespace
    assert_equal ['BAR'], bar.env_namespace
  end

  test 'defaults to env vars' do
    klass = Class.new(Hashr) do
      extend Hashr::EnvDefaults
      self.env_namespace = 'hashr'
      define foo: 'foo', bar: { baz: 'baz' }
    end

    ENV['HASHR_FOO'] = 'env foo'
    ENV['HASHR_BAR_BAZ'] = 'env bar baz'

    hashr = klass.new
    assert_equal 'env foo', hashr.foo
    assert_equal 'env bar baz', hashr.bar.baz

    # ENV.delete('HASHR_FOO')
    # ENV.delete('HASHR_BAR_BAZ')

    # hashr = klass.new
    # assert_equal 'foo', hashr.foo
    # assert_equal 'bar baz', hashr.bar.baz
  end
end
