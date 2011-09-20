require 'test/unit'
require 'Evalirator.rb'
require 'Judgement.rb'

class EvaliratorTest < Test::Unit::TestCase
  def setup
    j1 = Judgement.new(1, true)
    j2 = Judgement.new(2, false)
    j3 = Judgement.new(3, false)
    
    @e = Evalirator.new(j1, j2, j3)
    @e << 1
    @e << 4
    @e << 8
  end
  
  def test_precision_on_empty
    assert(Evalirator.new(Judgement.new(1, false)).precision.nan?)
  end
  
  def test_recall_on_empty
    assert(Evalirator.new(Judgement.new(1, false)).recall.nan?)
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
  
  def test_true_negatives
    assert_equal(2, @e.true_negatives)
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

