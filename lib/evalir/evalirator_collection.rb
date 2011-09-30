module Evalir
  class EvaliratorCollection
    include Enumerable
    
    def initialize
      @evalirators = []
    end
    
    def size
      @evalirators.size
    end

    # Calls block once for each element in self, 
    # passing that element as a parameter.
    def each(&block)
      @evalirators.each(&block)
    end
    
    # Adds an evalirator to the set over which
    # calculations are done.
    def <<(evalirator)
      @evalirators << evalirator
    end
    
    # Maps over all elements, executing
    # <em>blk</em> on every evalirator.
    def lazy_map(&blk)
      Enumerator.new do |yielder|
        self.each do |e|
          yielder << blk[e]
        end
      end
    end

    # Adds a list of relevant documents, and
    # a list of retrived documents. This rep-
    # resents one information need.
    def add(relevant_docids, retrieved_docids)
      @evalirators << Evalirator.new(relevant_docids, retrieved_docids)
    end
    
    # Mean Average Precision - this is just
    # a fancy way of saying 'average average
    # precision'!
    def mean_average_precision
      @evalirators.reduce(0.0) {|avg,e| avg + (e.average_precision / @evalirators.size)}
    end
    
    def mean_reciprocal_rank
      self.reduce(0.0) { |avg,e| avg + (e.reciprocal_rank / self.size)}
    end
    
    # Gets the data for the precision-recall
    # curve, ranging over the interval [<em>from</em>, 
    # <em>to</em>], with a step size of <em>step</em>.
    # This is the average over all evalirators.
    def precision_recall_curve(from = 0, to = 100, step = 10)
      raise "From must be in the interval [0, 100)" unless (from >= 0 and from < 100)
      raise "To must be in the interval (from, 100]" unless (to > from and to <= 100)
      raise "Invalid step size - (to-from) must be divisible by step." unless ((to - from) % step) == 0
      return nil if @evalirators.empty?

      steps = ((to - from) / step) + 1
      curves = self.lazy_map { |e| e.precision_recall_curve(from, to, step) }
      curves.reduce([0] * steps) do |acc, data|
        data.each_with_index.map do |d,i|
          acc[i] += d / self.size
        end
      end
    end
    
    # Gets the average Normalized Discounted
    # Cumulative Gain over all queries.
    def average_ndcg_at(k, logbase = 2)
      values = self.lazy_map {|e| e.ndcg_at(k, logbase)}
      values.reduce(0.0) { |acc, v| acc + (v / self.size) }
    end
  end
end