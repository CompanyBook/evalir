require 'test/unit'
require 'Evalirator.rb'

class EvaliratorRankedTest < Test::Unit::TestCase
  def setup
    @e = Evalirator.new(3, 5, 9, 25, 39, 44, 56, 71, 89, 123)
    @e << 123
    @e << 84
    @e << 56
    @e << 6
    @e << 8
    @e << 9
    @e << 511
    @e << 129
    @e << 187
    @e << 25
    @e << 38
    @e << 48
    @e << 250
    @e << 113
    @e << 3
  end
  
  def test_top_10_percent
    assert_equal([123, 84], @e.top_percent(10))
  end
  
  def test_precision_at_recall_10
    assert_equal(0.5, @e.precision_at_recall(10))
  end
end

