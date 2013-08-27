
def incremental_insert_iqm(filename='config/raw_data.txt')

  data = []
  File.open(filename, 'r') do |f|
    f.each_line do |line|

      # init values only once
      check_num = line.to_i

      puts "Observation ##{check_num} saved!" if Observation.find_or_create_by(value:check_num)

      if data.empty?
        data << check_num
      else
        index_pos = insert_sort(data, check_num)
        data.insert(index_pos, check_num)
      end

      # init values only once
      data_length = data.length

      if data_length >= 4
        quartile = data_length / 4.0
        ys       = data[quartile.ceil-1..(3*quartile).floor]
        factor   = quartile - (ys.length/2.0 - 1)

        mean = (ys[1...-1].inject(0, :+) + (ys[0] + ys[-1]) * factor) / (2*quartile)
        puts "#{data_length}: #{"%.2f" % mean}"

        # Iqm.create

      end
    end
  end

end



# returns the index of data where check_num should be inserted
def insert_sort(data, check_num)

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
