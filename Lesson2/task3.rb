fibbonaci = [0, 1]
  
loop do
  break if fibbonaci[-1] + fibbonaci[-2] > 100

  fibbonaci << fibbonaci[-1] + fibbonaci[-2]
end

puts fibbonaci
