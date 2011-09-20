class GoldStandard
  attr_accessor :information_need, :query, :relevant_docids
  
  def initialize information_need, query, *relevant_docids
    @information_need = information_need
    @query = query
    @relevant_docids = relevant_docids
  end  
end