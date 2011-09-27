module Evalir
  VERSION = '0.1'
  
  class Evalir
    @evalirators = []
  
    def add(relevant_docids, result_docids)
      e = Evalirator.new(relevant_docids)
      e.add(result_docids)
      @evalirators << e
    end
  end
end

path = File.expand_path(File.dirname(__FILE__))
$:.unshift path unless $:.include?(path)
require 'evalir/evalirator'