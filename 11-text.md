# 11 Text as Data

<br>

## Readings  

[Text Mining with R](https://www.tidytextmining.com/): [1](https://www.tidytextmining.com/tidytext) and [3](https://www.tidytextmining.com/tfidf)  

[Who Invented Instrumental Variable Regression?](https://www.aeaweb.org/articles?id=10.1257/089533003769204416) by James Stock and Francesco Trebbi

[Text as Data](https://press.princeton.edu/books/hardcover/9780691207544/text-as-data?srsltid=AfmBOopA2-mlPNcIhqmXGtI2BDycF3xnHLMJOczVJboRfjAzr_dfPoP0) the book is also great, but beyond the scope of this course.  

<br>

## Lecture 

[Slides from Lecture 11](https://pjakiela.github.io/ECON370/ECON370-L11-text-2025-handout.pdf)  

<br>

## Lab 

The objective of this lab is to adapt the template (available in [R](ECON370-lab11-2025-template.R) or [Python](ECON370-lab11-2025-template.py)) 
to cluster NBER working papers from two programs based on the abstracts. The template does this for Development Economics and Labor Studies. You 
must choose to different NBER programs. You should identify a (relatively) stable clustering that groups papers in a sensible way. You should extend the template 
as needed to identify the best possible clustering, including at least some of the following:

- Increasing the number of clusters
- Including additional preprocessing or stemming to group related words
- Using TF-IDF instead of term frequencies
- Excluding any words that only appear in a single working paper
- Clustering by principal components rather than term frequencies themselves

<br>

