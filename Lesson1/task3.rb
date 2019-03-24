print "Сторона треугольника A: "
a = gets.chomp.to_f

print "Сторона треугольника B: "
b = gets.chomp.to_f

print "Сторона треугольника C: "
c = gets.chomp.to_f

triangle = [a, b, c].sort
    
if triangle[2]**2 == triangle[0]**2 + triangle[1]**2
  puts "Треугольник прямоугольный."
  puts "Треугольник равнобедренный." if triangle[0] == triangle[1]
elsif triangle[0] == triangle[1] && triangle[0] == triangle[2]
  puts "Треугольник равнобедренный и равносторонний."
else
  puts "Треугольник не прямоугольный."
end
