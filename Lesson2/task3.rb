fibbonaci = [0, 1]
  
loop do
  fibbonaci_next_num = fibbonaci[-1] + fibbonaci[-2]

  break if fibbonaci_next_num > 100

  fibbonaci << fibbonaci_next_num
end

puts fibbonaci
