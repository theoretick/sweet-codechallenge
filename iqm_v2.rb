#!/usr/bin/ruby
# require 'profile' # TEMP:

def iqm_v2(filename='data.txt')

  data = []
  File.open(filename, 'r') do |f|
    f.each_line do |line|

      # init values only once
      check_num = line.to_i

      if data.empty?
        data << check_num
      else
        insert_index = insert_sort(data, check_num)
        data.insert(insert_index, check_num)
      end

      data_length = data.length

      if data_length >= 4
        quartile = data_length / 4.0

        ys = data[quartile.ceil-1..(3*quartile).floor]

        # if (and only if) check_num falls within IQ, recompute total_mean
        # if check_num >= quartile_2 && check_num <= quartile_3
        # if ys.include? check_num
          factor     = quartile - (ys.length/2.0 - 1)
          @mean       = (ys[1...-1].inject(0, :+) + (ys[0] + ys[-1]) * factor) / (2*quartile)
          total_mean = "#{data_length}: #{"%.2f" % @mean}"
        # end
      end
      puts total_mean
    end
    puts @mean.inspect
    return @mean
  end

end

# returns index of data to be inserted
def insert_sort(data, check_num)
  data.each_with_index do |data_point, index|
    if data_point > check_num
      return index
    else
      return -1
    end
  end
end


# iqm_v2('data-short.txt')
iqm_v2('data.txt')


# DATA-SHORT TEST W/ PROFILER

#   %   cumulative   self              self     total
#  time   seconds   seconds    calls  ms/call  ms/call  name2
#  66.15   173.92    173.92     9997    17.40    23.21  Array#include?
#  22.12   232.07     58.15 24337473     0.00     0.00  Fixnum#==
#   7.00   250.48     18.41     2152     8.55    11.40  Array#each
#   2.33   256.61      6.13  2491271     0.00     0.00  Fixnum#+
#   1.66   260.98      4.37     9997     0.44     0.44  Array#sort
#   0.42   262.08      1.10    10002     0.11    78.85  Object#iqm_v2
#   0.09   262.31      0.23     9997     0.02     0.04  IO#puts
#   0.06   262.46      0.15     9997     0.02     0.05  Kernel#puts
#   0.05   262.59      0.13        1   130.00 262920.00  IO#each_line
#   0.03   262.68      0.09    19994     0.00     0.00  IO#write
#   0.02   262.72      0.04     2152     0.02     0.02  String#%
#   0.01   262.75      0.03    10000     0.00     0.00  String#to_i
#   0.01   262.78      0.03     7845     0.00     0.00  NilClass#to_s
#   0.01   262.81      0.03    12149     0.00     0.00  Array#[]
#   0.01   262.84      0.03    12149     0.00     0.00  Fixnum#/
#   0.01   262.86      0.02    14301     0.00     0.00  Fixnum#*
#   0.01   262.88      0.02     2152     0.01     0.01  Float#-
#   0.01   262.90      0.02     9997     0.00     0.00  Float#ceil
#   0.01   262.92      0.02     9997     0.00     0.00  Float#floor
#   0.00   262.92      0.00        1     0.00     0.00  TracePoint#enable
#   0.00   262.92      0.00     2152     0.00     0.00  Fixnum#to_s
#   0.00   262.92      0.00     2152     0.00    11.40  Enumerable#inject
#   0.00   262.92      0.00        1     0.00     0.00  File#initialize
#   0.00   262.92      0.00        1     0.00     0.00  Module#method_added
#   0.00   262.92      0.00        1     0.00     0.00  MonitorMixin#mon_exit
#   0.00   262.92      0.00        1     0.00     0.00  Mutex#unlock
#   0.00   262.92      0.00        1     0.00     0.00  MonitorMixin#mon_check_owner
#   0.00   262.92      0.00        1     0.00     0.00  Thread.current
#   0.00   262.92      0.00        1     0.00     0.00  IO#close
#   0.00   262.92      0.00        1     0.00 262920.00  IO.open
#   0.00   262.92      0.00        1     0.00     0.00  TracePoint#disable
#   0.00   262.92      0.00        1     0.00 262920.00  #toplevel

# real  4m54.054s
# user  4m22.949s
# sys 0m30.354s



# AFTER OPTIMIZATIONS W/ DATA-SHORT

#  %   cumulative   self              self     total
#  time   seconds   seconds    calls  ms/call  ms/call  name
#  59.73    18.84     18.84     2152     8.75    11.66  Array#each
#  19.88    25.11      6.27  2491271     0.00     0.00  Fixnum#+
#  14.11    29.56      4.45     9997     0.45     0.45  Array#sort
#   3.46    30.65      1.09    10002     0.11     9.45  Object#iqm_v2
#   0.89    30.93      0.28    10000     0.03     0.03  IO#puts
#   0.54    31.10      0.17    10000     0.02     0.05  Kernel#puts
#   0.38    31.22      0.12        1   120.00 31540.00  IO#each_line
#   0.16    31.27      0.05    20000     0.00     0.00  IO#write
#   0.16    31.32      0.05    14301     0.00     0.00  Fixnum#*
#   0.13    31.36      0.04     2152     0.02     0.02  String#%
#   0.13    31.40      0.04    19791     0.00     0.00  Array#at
#   0.10    31.43      0.03     2152     0.01    11.68  Enumerable#inject
#   0.10    31.46      0.03    10000     0.00     0.00  String#to_i
#   0.06    31.48      0.02    12149     0.00     0.00  Array#[]
#   0.06    31.50      0.02     9997     0.00     0.00  Float#ceil
#   0.06    31.52      0.02     9997     0.00     0.00  Float#floor
#   0.06    31.54      0.02     7848     0.00     0.00  NilClass#to_s
#   0.00    31.54      0.00        1     0.00     0.00  TracePoint#enable
#   0.00    31.54      0.00    12149     0.00     0.00  Fixnum#/
#   0.00    31.54      0.00        1     0.00     0.00  File#initialize
#   0.00    31.54      0.00     2152     0.00     0.00  Float#-
#   0.00    31.54      0.00        1     0.00     0.00  Module#method_added
#   0.00    31.54      0.00        1     0.00     0.00  MonitorMixin#mon_exit
#   0.00    31.54      0.00        1     0.00     0.00  Mutex#unlock
#   0.00    31.54      0.00     2152     0.00     0.00  Fixnum#to_s
#   0.00    31.54      0.00        1     0.00     0.00  MonitorMixin#mon_check_owner
#   0.00    31.54      0.00        1     0.00     0.00  Thread.current
#   0.00    31.54      0.00        1     0.00     0.00  IO#close
#   0.00    31.54      0.00        1     0.00 31540.00  IO.open
#   0.00    31.54      0.00        1     0.00     0.00  TracePoint#disable
#   0.00    31.54      0.00        1     0.00 31540.00  #toplevel

# real  0m34.805s
# user  0m31.570s
# sys 0m3.197s