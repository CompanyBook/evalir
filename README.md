What is Evalir?
===============
Evalir is a library for evaluation of IR systems. It incorporates a number of standard measurements, from the basic precision and recall, to single value summaries such as NDCG and MAP.

For a good reference on the theory behind this, please check out Manning, Raghavan & Schützes excellent [Introduction to Information Retrieval, ch.8](http://nlp.stanford.edu/IR-book/html/htmledition/evaluation-in-information-retrieval-1.html).

What can Evalir do?
-------------------
* [Precision](http://en.wikipedia.org/wiki/Information_retrieval#Precision)
* [Recall](http://en.wikipedia.org/wiki/Information_retrieval#Recall)
* Precision at Recall (e.g. Precision at 20%)
* Precision at rank k
* Average Precision
* Precision-Recall curve
* Reciprocal Rank
* [Mean Reciprocal Rank](http://en.wikipedia.org/wiki/Mean_reciprocal_rank)
* [Mean Average Precision (MAP)](http://en.wikipedia.org/wiki/Information_retrieval#Mean_average_precision)
* [F-measure](http://en.wikipedia.org/wiki/Information_retrieval#F-measure)
* [R-Precision](http://en.wikipedia.org/wiki/Information_retrieval#R-Precision)
* [Discounted Cumulative Gain (DCG)](http://en.wikipedia.org/wiki/Discounted_cumulative_gain)
* [Normalized DCG](http://en.wikipedia.org/wiki/Discounted_cumulative_gain#Normalized_DCG)

How does Evalir work?
---------------------
The goal of an Information Retrieval system is to provide the user with relevant information -- relevant w.r.t. the user's *information need*. For example, an information need might be:

> Information on whether drinking red wine is more effective at reducing your risk of heart attacks than white wine.

However, this is *not* the query. A user will try to encode her need like a query, for instance:

> red white wine reducing "heart attack"

To evaluate an IR system with Evalir, we will need human-annotated test data, each data point consisting of the following:

* An explicit information need
* A query
* A list of documents that are relevant w.r.t. the information need (*not* the query)

For example, we have the aforementioned information need and query, and a list of documents that have been found to be relevant; { 123, 654, 29, 1029 }. If we had the actual query results in an array named *results*, we could use an Evalirator like this:

``` ruby
require 'rubygems'
require 'evalir'

relevant = [123, 654, 29, 1029]
e = Evalir::Evalirator.new(relevant, results)
puts "Precision: #{e.precision}"
puts "Recall: #{e.recall}"
puts "F-1: #{e.f1}"	
puts "F-3: #{e.f_measure(3)}"
puts "Precision at rank 10: #{e.precision_at_rank(10)}"
puts "Average Precision: #{e.average_precision}"
puts "NDCG @ 5: #{e.ndcg_at(5)}"
```	

When you have several information needs and want to compute aggregate statistics, use an EvaliratorCollection like this:

``` ruby
e = Evalir::EvaliratorCollection.new
queries.each do |query|
  relevant = get_relevant_docids(query)
  results = get_results(query)
  e.add(relevant, results)
end
	
puts "MAP: #{e.mean_average_precision}"
puts "Precision-Recall Curve: #{e.precision_recall_curve}"
puts "Avg. NDCG @ 3: #{e.average_ndcg_at(3)}"
```
