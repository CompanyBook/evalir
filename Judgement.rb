class Judgement
  attr_accessor :docid
  
  def initialize docid, is_relevant
    @docid = docid
    @is_relevant = is_relevant
  end
  
  def relevant?
    @is_relevant
  end
end