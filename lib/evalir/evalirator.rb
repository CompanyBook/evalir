require 'set'

module Evalir
  class Evalirator
    # Gets the number of retrieved results 
    # that were indeed relevant.
    attr_reader :true_positives
    
    # Gets the number of retrieved results
    # that were in fact irrelevant.
    attr_reader :false_positives
    
    # Instantiates a new instance of the
    # Evalirator, using the provided judgements
    # as a basis for later calculations.
    def initialize(relevant_docids, retrieved_docids = [])
      @relevant_docids = relevant_docids.to_set
      @true_positives = @false_positives = 0
      @search_hits = []
      
      retrieved_docids.each do |docid|
        if @relevant_docids.include? docid
          @true_positives = @true_positives + 1
        else
          @false_positives = @false_positives + 1
        end
        @search_hits << docid
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
      @relevant_docids.size - @true_positives
    end
  
    # Calculate the precision, e.g. the
    # fraction of retrieved documents that
    # were relevant.
    def precision
      @true_positives / size
    end
  
    # Calculate the recall, e.g. the
    # fraction of relevant documents that
    # were retrieved.
    def recall
      fn = false_negatives
      @true_positives / (@true_positives + fn + 0.0)
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
      return 1.0 if r == 0.0
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
    
    # Gets the data for the precision-recall
    # curve, ranging over the interval [<em>from</em>, 
    # <em>to</em>], with a step size of <em>step</em>.
    def precision_recall_curve(from = 0, to = 100, step = 10)
      raise "From must be in the interval [0, 100)" unless (from >= 0 and from < 100)
      raise "To must be in the interval (from, 100]" unless (to > from and to <= 100)
      raise "Invalid step size - (to-from) must be divisible by step." unless ((to - from) % step) == 0
      
      data = []
      range = from..to
      range.step(step).each do |recall|
        data << self.precision_at_recall(recall/100.0)
      end
      data
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
    
    # The reciprocal rank, meaning
    # 1 divided by the rank of the
    # most highly ranked relevant
    # result.
    def reciprocal_rank
      @search_hits.each_with_index do |h,i|
        return 1.0 / (i + 1) if @relevant_docids.include? h
      end
      return 0.0
    end
    
    # Discounted Cumulative Gain at
    # rank k. For a relevant search
    # result at position x, its con-
    # tribution to the DCG is 
    # 1.0/Math.log(x, logbase). A
    # higher logbase means more dis-
    # counts for results further out.
    def dcg_at(k, logbase=2)
      i = 1
      dcg = 0.0
      @search_hits[0, k].each do |h|
        if @relevant_docids.include? h
          dcg += i == 1 ? 1.0 : 1.0 / Math.log(i, logbase)
        end
        i += 1
      end
      dcg
    end
    
    # Normalized Discounted Cumulative
    # Gain at rank <em>k</em>. This is
    # the #dcg_at normalized by the optimal
    # dcg value at rank k.
    def ndcg_at(k, logbase=2)
      dcg = dcg_at(k, logbase)
      dcg > 0 ? dcg / ideal_dcg_at(k, logbase) : 0
    end
    
    private
      def ideal_dcg_at(k, logbase=2)
        idcg = 0.0
        n = @true_positives
        (1..k).each do |i|
          break unless n > 0
          idcg += i == 1 ? 1.0 : 1.0 / Math.log(i, logbase)
          n -= 1
        end
        idcg
      end
  end
end