require 'book_test_helper'

class ParametersTest < Test::Unit::TestCase
  include BookTestHelper

  def test_s_default
    assert Book::Parameters.default
  end

  def test_s_load
    Tempfile.open('parameters_test') do |io|
      io.puts 'CHAPS_FILE = "x_CHAPS"'
      io.puts 'PAPER = "B5"' # XXX: avoid erros of the last line of Parameters.get_page_metric
      io.close

      params = Book::Parameters.load(io.path)
      assert_equal '/x_CHAPS', params.chapter_file # XXX: OK? (leading / and uninitialized @basedir)
      assert_equal '/PART', params.part_file
    end
  end

  def test_s_get_page_metric
    mod = Module.new
    assert_raises ArgumentError do # XXX: OK?
      params = Book::Parameters.get_page_metric(mod)
      assert params
    end

    mod = Module.new
    mod.module_eval { const_set(:PAPER, 'A5') }
    assert_nothing_raised do
      params = Book::Parameters.get_page_metric(mod)
      assert params
    end

    mod = Module.new
    mod.module_eval { const_set(:PAPER, 'X5') }
    assert_raises ConfigError do
      Book::Parameters.get_page_metric(mod)
    end
  end
end
