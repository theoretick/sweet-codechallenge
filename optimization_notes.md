Replace @file.each_line with single read + @array.each
  nearly identical speed

Tried different interpreters
  jruby much slower
  rubinius about the same as MRI




Replaced multi-use method calls with single assignment initialization (data.length)

Replaced array[] with array.at() which is supposedly mildly more performant (Ruby Cookbook, p.149)

Added a by-pass to prevent unnecessary mean calc if number falls outside of
the interquartile distribution.

Originally used #include? but was quite expensive.  #include?
sped up algorithm by about 10%.  I was surprised that it wasn't a more
significant performance increase so I continued to look at other solutions.

Running profiler showed the most expensive methods to be

#-----

  Please provide the optimized code, a test that proves that your code works, and answers to the following questions:



  Hey Justin!

  Thanks for the challenge, it was a fun exercise and I can totally see
  how this would be relevant to the work you guys do.  I banged my head
  against the wall with minor optimizations for a day before realizing
  that I really only needed to calculate 50% of the averages after all.

  I made the webapp too, its up on heroku over here: !!!!!!!!!!!!!!!

  Original runtime of the v1 code on my Macbook was ```real  10m30.413s```.
  After my optimizations I got it down to ``` ```.

1) Explain how your optimization works and why you took this approach

  The main approach I took during optimization involved only calculating the
  mean if the current observation fell within the interquartile range.  As
  that was the only range we cared about, other than updating the quartile
  values it is unnecessary to recalculate the mean if the number does not
  fall within that mid-range. This optimization decreased the runtime by ~10%.

  I originally used #include? to test presence of the enumerable in the IQ
  but after running profiler (see footer) it proved to be a pretty expensive
  operation.  I checked around for alternatives to the #include? method and
  ended up evaluating "data[0] <= check_num <= data[-1]" (pseudocode).
  This change also saved about 10% in runtime.

  Many secondary optimizations I made were to initialize some of the commonly
  used variables in the beginning of the #each_line block so they are only
  calculated once, such as data.length.  I also replaced Array.index references
  (i.e. foo[0]) with the #at method (i.e. foo.at(0)) which is supposedly
  slightly faster ("Ruby Cookbook", p.149).  I noticed no noticeable increase
  with these two changes, however it may appear with significantly larger
  datasets.

2) Would your approach continue to work if there were millions or billions of input values?

  Yes, my approach will continue to work regardless of the size of data.
  As the amount grows it will only check those observations that are within
  the relevant 2nd & 3rd quartiles. This is equally important at a dataset
  of any size.

3) Would your approach still be efficient if you needed to store the intermediate state between each IQM calculation in a data store?  If not, how would you change it to meet this requirement?

  Yes, by writing to the store only if the mean requires updating, I avoided
  the need for spurious writes of the same number to a persistent data store.
  At the intermediate state the last computed value would be held in storage
  and remain accessible until it is updated.


