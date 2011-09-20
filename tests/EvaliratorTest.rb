require 'test/unit'
require 'Evalirator.rb'

class EvaliratorTest < Test::Unit::TestCase
  def setup
    @e = Evalirator.new(1)
    @e << 1
    @e << 4
    @e << 8
  end
  
  def test_precision_on_empty
    assert(Evalirator.new(1).precision.nan?)
  end
  
  def test_recall_on_empty
    assert(Evalirator.new(1).recall.nan?)
  end
  
  def test_precision
    assert_equal(1.0/3, @e.precision)
  end
  
  def test_recall
    assert_equal(1.0, @e.recall)
  end
  
  def test_size
    assert_equal(3.0, @e.size)
  end

  def test_f1
    assert_equal(0.5, @e.f1)
  end
  
  def test_f_measure_1
    assert_equal(0.5, @e.f_measure(1.0))
  end
  
  def test_f05
    assert_equal('0.384615384615385', @e.f_measure(0.5).to_s)
  end
  
  def test_f3
    assert_equal('0.833333333333333', @e.f_measure(3.0).to_s)
  end
end

