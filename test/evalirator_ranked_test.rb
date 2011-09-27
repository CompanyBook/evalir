require 'test/unit'
require 'Evalirator.rb'

class EvaliratorRankedTest < Test::Unit::TestCase
  def setup
    @e = Evalirator.new(3, 5, 9, 25, 39, 44, 56, 71, 89, 123)
    [123,84,56,6,8,9,511,129,187,25,38,48,250,113,3].each do |i|
      @e << i
    end
  end
  
  def test_top_10_percent
    assert_equal([123, 84], @e.top_percent(10))
  end
  
  def test_precision_at_recall_10
    assert_equal(0.5, @e.precision_at_recall(10))
  end
  
  def test_r_precision
    assert_equal(0.4, @e.r_precision)
  end
end

