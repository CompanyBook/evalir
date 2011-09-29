require 'test/unit'
require_relative '../lib/evalir'

class EvaliratorUnrankedTest < Test::Unit::TestCase
  def setup
    @e = Evalir::Evalirator.new(1)
    @e.add(1,4,8)
  end
  
  def test_precision_on_empty
    assert(Evalir::Evalirator.new(1).precision.nan?)
  end
  
  def test_recall_on_empty
    assert_equal(0, Evalir::Evalirator.new(1).recall)
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
  
  def test_false_negatives
    assert_equal(0, @e.false_negatives)
  end
  
  def test_true_positives
    assert_equal(1, @e.true_positives)
  end
  
  def test_false_positives
    assert_equal(2, @e.false_positives)
  end
  
  def test_f1
    assert_equal(0.5, @e.f1)
  end
  
  def test_f_measure_1
    assert_equal(0.5, @e.f_measure(1.0))
  end
  
  def test_f05
    assert_equal(0.38, @e.f_measure(0.5).round(2))
  end
  
  def test_f3
    assert_equal(0.833, @e.f_measure(3.0).round(3))
  end
end

