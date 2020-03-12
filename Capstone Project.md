<style>

/* slide titles */
.section .reveal .state-background {
background: black;
}
.section .reveal p {
font-family: Verdana, Arial, Helvetica, sans-serif;
color: rgb(255, 255, 255);
text-align:right; width:80%;
line-height: 0.1em;
#margin-top: 70px;
}
.section .reveal h1, .section .reveal h2, .section {
font-family: Verdana, Arial, Helvetica, sans-serif;
color: #2B89F9;
margin-top: 50px;
}
.reveal pre code {
	font-family: Verdana, Arial, Helvetica, sans-serif;
  background-color: #E8F6FC;
  color: green;
  font-size: 40px;
  #position: fixed; top: 90%;
  #text-align:center; width:100%;
  }
.reveal h3 { 
  font-size: 65px;
  color: #2B89F9  ;
}

/* heading for slides with two hashes ## */
.reveal .slides section .slideContent h2 {
   font-size: 37px;
   font-weight: bold;
   color: green;
}

/* ordered and unordered list styles */
.reveal ul, 
.reveal ol {
    font-size: 37px;
    color: #FF5733;
    list-style-type: square;
  
  .reveal h1, .reveal h2, .reveal h3 {
  word-wrap: normal;
  -moz-hyphens: none;
  }

</style>

A Text Predictor Application
========================================================
author: Umar Ayoub
autosize: true


<h3>Predicting Text using Ngrams</h3>
+ Coursera

![alt text](courseral.png) 

+ Johns HopkinsBloomberg School of Public Health

![alt text](johns.jpg) 


+ Swiftkey

![alt text](swiftk.png) 

              
                      


Overview
========================================================
<style>

/* slide titles */
.section .reveal .state-background {
background: black;
}
</style>
***The objective of this project is to build working predictive text model***


**The App is a web-based application built in Shiny**

**The data used in this model came form **corpus** called HC Corpora**

**The algorithm was based on a classic **N-gram** model**

**The n-gram objects are saved as R-Compressed files**


Data
======================================================== 
The data provided consisted of 3 large files blogs, twitter, news.
A subset of the original data was sampled.
Sampling the data was necessary as it improved the performance
And reduced the work load making the analysis and model trainig easy

Data cleaning was done by coversion to lowercase, strip white space, removing punctuation and numbers.

The data used for building the __predictive model__ was provided by [HC Corpora] (http://www.corpora.heliohost.org/)
<div class="footer" style="font-size:80%;"> 
* More information can be found in the <a href="https://rpubs.com/UmAr1103/582328">Capstone milestone report</a></div>




The App NxWord
=======================================================
A shiny application NxWord that accepts a 
phrase as input, suggests word, sentence completion from the unigrams, and predicts the most likely next word based 
on the linear interpolation of fourgrams, trigrams, bigrams, and unigrams.
The application can be found at
<a href="https://umar1103.shinyapps.io/nxWords/"> **Here**</a>

<h3> Using The Application </h3>
To use the App, Type word or sentence in the input box
Use the Go button to get the predicted word
After Getting the first predicted word try to input the predicted word 
in the input box

![alt text](APP0.png)





