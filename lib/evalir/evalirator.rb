require 'set'

module Evalir
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
      else
        @fp = @fp + 1
      end      
    end
  
    # Adds a number of search hits which
    # are to be evaluated. For ranked eval-
    # uation, it's important that hits are
    # added in the order they were returned.
    def add(*search_hit)
      search_hit.each do |h| 
        self.<<(h)
      end
    end

    # Gets the size of the evaluated set,
    # e.g. the number of search hits added.
    def size
      @search_hits.size.to_f
    end

    # Calculate the number of false negatives.
    # Divide by #size to get the rate, e.g:
    # fn_rate = e.false_negatives / e.size
    def false_negatives
      @relevant_docids.size - @tp
    end
  
    # Calculate the precision, e.g. the
    # fraction of retrieved documents that
    # were relevant.
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
  
    # Returns the top p percent hits
    # that were added to this evalirator.
    def top_percent(p)
      k = size * (p / 100.0)
      @search_hits[0,k.ceil]
    end
    
    # The precision at the rank k, 
    # meaning the precision after exactly
    # k documents have been retrieved.
    def precision_at_rank(k)
      top_k = @search_hits[0, k].to_set
      (@relevant_docids & top_k).size.to_f / k
    end

    # Returns the precision at r percent
    # recall. Used to plot the Precision
    # vs. Recall curve.
    def precision_at_recall(r)
      k = (size * r).ceil
      top_k = @search_hits[0, k].to_set
      (@relevant_docids & top_k).size.to_f / k
    end
  
    # A single value summary which is
    # obtained by computing the precision
    # at the R-th position in the ranking.
    # Here, R is the total number of
    # relevant documents for the current
    # query.
    def r_precision
      r = @relevant_docids.size
      top_r = @search_hits[0, r].to_set
      (@relevant_docids & top_r).size.to_f / r
    end
    
    # The average precision. This is
    # equivalent to the average of calling
    # #precision_at_rank with 1..n, n
    # being the number of results.
    def average_precision
      n = 0
      avg = 0.0
      relevant = 0

      @search_hits.each do |h|
        n = n + 1
        if @relevant_docids.include? h
          relevant = relevant + 1
          avg += (relevant.to_f / n) / @relevant_docids.size
        end
      end
      avg
    end
  end
end