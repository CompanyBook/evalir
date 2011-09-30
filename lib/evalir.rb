require 'evalir/evalirator'

module Evalir
  class EvaliratorCollection
    include Enumerable
    
    def initialize
      @evalirators = []
    end

    def each(&block)
      @evalirators.each(&block)
    end
    
    def <<(evalirator)
      @evalirators << evalirator
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
    def map
      avg = 0.0
      @evalirators.each do |e|
        avg += (e.average_precision / @evalirators.size)
      end
      avg
    end
  end
end