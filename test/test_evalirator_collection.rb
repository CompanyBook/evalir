require 'test/unit'
require_relative '../lib/evalir'

class EvaliratorCollectionTest < Test::Unit::TestCase
  def setup
    @e = Evalir::EvaliratorCollection.new()
    @e.add([1,3,6,9,10], [1,2,3,4,5,6,7,8,9,10])
    @e.add([2,5,7], [1,2,3,4,5,6,7,8,9,10])
  end
  
  def test_map
    assert_equal(0.53, @e.map.round(2))
  end
  
  def test_simple_enumeration
    assert_equal(2, @e.count)
  end
end