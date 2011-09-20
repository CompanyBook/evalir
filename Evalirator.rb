require 'set'

class Evalirator
  # Instantiates a new instance of the
  # Evalirator, using the provided judgements
  # as a basis for later calculations.
  def initialize(*relevant_docids)
    @relevant_docids = relevant_docids.to_set
    @tp = @fp = 0
    @search_hits = []
  end
  
  # Adds a search hit to be evaluated.
  # For ranked evaluation, it's important
  # that hits are added in the order they
  # were returned.
  def <<(search_hit)
    @search_hits << search_hit
    if @relevant_docids.include? search_hit
      @tp = @tp + 1
      @relevant_docids.delete search_hit
    else
      @fp = @fp + 1
    end      
  end

  # Gets the size of the evaluated set,
  # e.g. the number of search hits added.
  def size
    @search_hits.size * 1.0
  end

  # Calculate the number of false negatives.
  # Divide by #size to get the rate, e.g:
  # fn_rate = e.true_negatives / e.size
  def false_negatives
    @relevant_docids.size
  end
  
  # Calculate the precision, e.g. the
  # fraction of returned documents that
  # were retrieved.
  def precision
    @tp / size
  end
  
  # Calculate the recall, e.g. the
  # fraction of relevant documents that
  # were retrieved.
  def recall
    fn = false_negatives
    @tp / (@tp + fn + 0.0)
  end
  
  # Calculate the evenly weighted
  # harmonic mean of #precision and 
  # #recall. This is equivalent to
  # calling #f_measure with a parameter
  # of 1.0.
  def f1
    f_measure(1.0)
  end
  
  # Calculate the weighted harmonic
  # mean of precision and recall -
  # β > 1 means emphasizing recall,
  # β < 1 means emphasizing precision.
  # β = 1 is equivalent to #f1.
  def f_measure(beta)
    betaSquared = beta ** 2
    n = (betaSquared + 1) * (precision * recall)
    d = (betaSquared * precision) + recall
    n / d
  end
end