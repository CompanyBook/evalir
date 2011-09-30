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
      avg = 0.0
      @evalirators.each do |e|
        avg += (e.average_precision / @evalirators.size)
      end
      avg
    end
    
    # Gets the data for the precision-recall
    # curve, ranging over the interval [<em>from</em>, 
    # <em>to</em>], with a step size of <em>step</em>.
    # This is the average over all evalirators.
    def precision_recall_curve(from = 0, to = 100, step = 10)
      return nil if @evalirators.empty?
      
      #n = self.size.to_f
      x = 1
      curves = self.lazy_map { |e| e.precision_recall_curve(from, to, step) }
      return curves.reduce do |acc, data|
        x += 1
        data.each_with_index.map do |d,i|
          acc[i] = (acc[i] + d) / x
        end
      end
    end
  end
end