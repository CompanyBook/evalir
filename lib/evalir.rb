module Evalir
  VERSION = '0.1'
  
  class Evalir
    def initialize
      @evalirators = []
    end

    # Adds a list of relevant documents, and
    # a list of retrived documents. This rep-
    # resents one information need.
    def add(relevant_docids, result_docids)
      e = Evalirator.new(*relevant_docids)
      e.add(*result_docids)
      @evalirators << e
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

path = File.expand_path(File.dirname(__FILE__))
$:.unshift path unless $:.include?(path)
require 'evalir/evalirator'