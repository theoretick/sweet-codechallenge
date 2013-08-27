
#-----

OPTIONAL EXTRA CHALLENGE: Turn this into a simple web application.  Present a field where an integer value between 0 and 600 can be inputted and display to the user the IQM calculation of all the values that have been so far entered, allowing the user to continue to enter numbers while seeing the IQM being recomputed.  Use your incremental IQM calculation so that this web application could scale to calculate the IQM on large numbers of input values.  Persist the intermediate state of your IQM calculation so that this web application would continue to work if data were being entered simultaneously from multiple servers.


web app
input field for integer (0..600)
display IQM calc for all values so far entered
enter numbers to see IQM recomputed
persist intermediate state of IQM calculations
  (to support simultaneous entry from diff points)




#-----


  Hey Justin!

  Thanks for the challenge, it was a fun exercise and I can totally see
  how this would be relevant to the work you guys do.  I banged my head
  against the wall with minor optimizations for a bit before taking a
  look at that sorting method and reading up a bit on ruby's #sort
  implementation.

  I made the webapp too, its up on heroku over here: !!!!!!!!!!!!!!!

  Original runtime of the v1 code on my Macbook was ```real  10m30.413s```.
  After my optimizations I got it down to ```real 7m25.126s```, ~30% faster.


1) Explain how your optimization works and why you took this approach

  The main approach I took during optimization involved modifying the
  sorting algorithm used.  I ran profiler and took a look at the most
  expensive operations, of which #sort was included. Ruby's built-in sort
  is a generic implementation of a quicksort which, while often efficient,
  is extremely slow when acting on a nearly-sorted list. The v1 code is
  continuously using the expensive #sort method with only single additions
  to the end of a sorted set.  Instead, by using an insert_sort it prevents
  such an expensive operation.  By writing one it cut computation down
  dramatically.

  A couple secondary optimizations I made were to initialize some of the
  commonly used variables in the beginning of the #each_line block so they
  are only calculated once, such as data.length.  I also replaced index
  references (i.e. foo[0]) with the #at method (i.e. foo.at(0)) which is
  supposedly slightly faster ("Ruby Cookbook", p.149).  I noticed no
  noticeable increase with these two changes, however it may appear with
  significantly larger datasets. For readability sake, I reverted back to
  #[] method calls rather than the weirder #at.

2) Would your approach continue to work if there were millions or billions of input values?

  Yes, my approach will continue to work regardless of the size of data.
  It will be far more efficient than the previous version on larger sets
  as #sort will get progressively more expensive the larger the dataset gets.

3) Would your approach still be efficient if you needed to store the intermediate state between each IQM calculation in a data store?  If not, how would you change it to meet this requirement?

  Yes, my approach would still remain efficient as the intermediate state
  of the last computed value would be held in storage and remain accessible
  until it is updated.


