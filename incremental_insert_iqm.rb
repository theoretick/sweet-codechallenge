#!/usr/bin/ruby
# require 'profile' # TEMP:

def incremental_insert_iqm(filename='data.txt')

  data = []
  File.open(filename, 'r') do |f|
    f.each_line do |line|

      # init value only once to save recalc
      check_num = line.to_i

      # adds check_num to data set in proper order position
      index_pos = insert_sort(data, check_num)
      data.insert(index_pos, check_num)

      # init value only once to save recalc
      data_length = data.length

      if data_length >= 4
        quartile  = data_length / 4.0
        ys        = data[(quartile.ceil-1)..(3 * quartile).floor]
        factor    = quartile - (ys.length/2.0 - 1)

        iq_sum    = ys[1...-1].inject(0, :+)
        quantiles = (ys[0] + ys[-1]) * factor

        @mean = (iq_sum + quantiles) / (2 * quartile)
        puts "#{data_length}: #{"%.2f" % @mean}"
      end
    end
    return @mean
  end

end


# returns the index of data where check_num should be inserted
def insert_sort(data, check_num)

  return 0 if data.empty?

  halfway = (data.length / 2) - 1

  # halfway quick-check to speed up full-scan of big arrays
  if data[halfway] < check_num
    data[halfway..-1].each_with_index do |data_point, index|
      if data_point > check_num
        return index + halfway
      end
    end
  else
    data.each_with_index do |data_point, index|
      if data_point > check_num
        return index
      end
    end
  end
  return -1
end


incremental_insert_iqm('data-short.txt')
# incremental_insert_iqm('data.txt')


# DATA-SHORT TEST W/ PROFILER

#   %   cumulative   self              self     total
#  time   seconds   seconds    calls  ms/call  ms/call  name2
#  66.15   173.92    173.92     9997    17.40    23.21  Array#include?
#  22.12   232.07     58.15 24337473     0.00     0.00  Fixnum#==
#   7.00   250.48     18.41     2152     8.55    11.40  Array#each
#   2.33   256.61      6.13  2491271     0.00     0.00  Fixnum#+
#   1.66   260.98      4.37     9997     0.44     0.44  Array#sort
#   0.42   262.08      1.10    10002     0.11    78.85  Object#incremental_insert_iqm
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

