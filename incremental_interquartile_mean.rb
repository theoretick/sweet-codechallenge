#!/usr/bin/ruby
data = []
File.open('data-short.txt','r') do |f|
  f.each_line do |l|
    data << l.to_i
    if data.length >= 4
      q = data.size / 4.0
      ys = data.sort[q.ceil-1..(3*q).floor]
      factor = q - (ys.size/2.0 - 1)

      mean = (ys[1...-1].inject(0, :+) + (ys[0] + ys[-1]) * factor) / (2*q)
      puts "#{data.length}: #{"%.2f" % mean}"
    end
  end
end

# COLD RUN
# 100000: 458.82

# real  10m30.413s
# user  10m24.092s
# sys 0m5.517s



#   %   cumulative   self              self     total
#  time   seconds   seconds    calls  ms/call  ms/call  name
#  72.84   211.59    211.59     9997    21.17    28.25  Array#each
#  24.37   282.38     70.79 25004997     0.00     0.00  Fixnum#+
#   1.66   287.19      4.81     9997     0.48     0.48  Array#sort
#   0.63   289.02      1.83    10001     0.18    58.08  nil#
#   0.10   289.30      0.28     9997     0.03     0.04  IO#puts
#   0.07   289.50      0.20     9997     0.02     0.06  Kernel#puts
#   0.05   289.64      0.14     9997     0.01     0.01  String#%
#   0.05   289.78      0.14     9997     0.01    28.26  Enumerable#inject
#   0.04   289.91      0.13        1   130.00 290480.00  IO#each_line
#   0.04   290.03      0.12    19994     0.01     0.01  IO#write
#   0.04   290.14      0.11    19994     0.01     0.01  Array#[]
#   0.03   290.23      0.09    19994     0.00     0.00  Fixnum#/
#   0.02   290.28      0.05    10000     0.01     0.01  String#to_i
#   0.02   290.33      0.05     9997     0.01     0.01  Fixnum#to_s
#   0.01   290.37      0.04     9997     0.00     0.00  Float#floor
#   0.01   290.41      0.04    29991     0.00     0.00  Fixnum#*
#   0.01   290.45      0.04     9997     0.00     0.00  Float#-
#   0.01   290.48      0.03     9997     0.00     0.00  Float#ceil
#   0.00   290.48      0.00        1     0.00     0.00  TracePoint#enable
#   0.00   290.48      0.00        1     0.00     0.00  File#initialize
#   0.00   290.48      0.00        1     0.00     0.00  MonitorMixin#mon_exit
#   0.00   290.48      0.00        1     0.00     0.00  Mutex#unlock
#   0.00   290.48      0.00        1     0.00     0.00  MonitorMixin#mon_check_owner
#   0.00   290.48      0.00        1     0.00     0.00  Thread.current
#   0.00   290.48      0.00        1     0.00     0.00  IO#close
#   0.00   290.48      0.00        1     0.00 290480.00  IO.open
#   0.00   290.48      0.00        1     0.00     0.00  TracePoint#disable
#   0.00   290.48      0.00        1     0.00 290480.00  #toplevel


# DATA-SHORT RUN
#
# real  5m28.931s
# user  4m50.516s
# sys 0m31.459s

