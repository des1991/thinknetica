print "Коэффициент A: "
a = gets.to_f

print "Коэффициент B: "
b = gets.to_f

print "Коэффициент C: "
c = gets.to_f

D = b**2 - 4 * a * c

if D < 0
  puts "Дискриминант = #{D}, корней нет." 
elsif D == 0
  puts "Дискриминант = #{D}, корень = #{-b / (2 * a)}."
else
  D_sqrt = Math.sqrt(D)
  x1 = (-b + D_sqrt) / (2 * a)
  x2 = (-b - D_sqrt) / (2 * a)
  puts "Дискриминант = #{D}, корень 1 = #{x1}, корень 2 = #{x2}"
end
