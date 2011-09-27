require 'test/unit'
require_relative '../lib/evalir'

class EvaliratorRankedTest < Test::Unit::TestCase
  def setup
    @e = Evalir::Evalirator.new(3, 5, 9, 25, 39, 44, 56, 71, 89, 123)
    [123,84,56,6,8,9,511,129,187,25,38,48,250,113,3].each do |i|
      @e << i
    end
  end

  def test_adding_result_array
    e2 = Evalir::Evalirator.new(3, 5, 9, 25, 39, 44, 56, 71, 89, 123)
    e2.add(123,84,56,6,8,9,511,129,187,25,38,48,250,113,3)
    assert_equal(@e.r_precision, e2.r_precision)
  end
  
  def test_top_10_percent
    assert_equal([123, 84], @e.top_percent(10))
  end
  
  def test_precision_at_rank_6
    assert_equal(0.5, @e.precision_at_rank(6))
  end
  
  def test_precision_at_recall_0_1
    assert_equal(0.5, @e.precision_at_recall(0.1))
  end
  
  def test_r_precision
    assert_equal(0.4, @e.r_precision)
  end
  
  def test_average_precision
    e1 = Evalir::Evalirator.new(1,3,4,5,6,10)
    e1.add(1,2,3,4,5,6,7,8,9,10)
    assert_equal(0.78, e1.average_precision.round(2))
    
    e2 = Evalir::Evalirator.new(2,5,6,7,9,10)
    e2.add(1,2,3,4,5,6,7,8,9,10)
    assert_equal(0.52, e2.average_precision.round(2))
  end
end

