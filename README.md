What is Evalir?
===============
Evalir is a library for evaluation of IR systems. It incorporates a number of standard measurements, from the basic precision and recall, to single value summaries such as NDCG and MAP.

For a good reference on the theory behind this, please check out Manning, Raghavan & Schützes excellent [Introduction to Information Retrieval, ch.8](http://nlp.stanford.edu/IR-book/html/htmledition/evaluation-in-information-retrieval-1.html).

What can Evalir do?
-------------------
* Precision
* Recall
* Precision at Recall (e.g. Precision at 20%)
* F-measure
* R-Precision

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

For example, we have the aforementioned information need and query, and a list of documents that have been found to be relevant; { 123, 654, 29, 1029 }. If we had the actual query results in an array named *results*, we could use Evalir like this:

    e = Evalirator.new(123, 654, 29, 1029)
    results.each { |r| e << r }
    puts "Precision: #{e.precision}"
    puts "Recall: #{e.recall}"
    puts "F-1: #{e.f1}"	
    puts "F-3: #{e.f_measure(3)}"