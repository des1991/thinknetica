print "Сторона треугольника A: "
a = gets.chomp.to_f

print "Сторона треугольника B: "
b = gets.chomp.to_f

print "Сторона треугольника C: "
c = gets.chomp.to_f

if a > b && a > c
	g = a
	c1 = b
	c2 = c 
elsif b > a && b > c
	g = b
	c1 = a
	c2 = c
else
	g = c
	c1 = a
	c2 = b
end
		
if g**2 == c1**2 + c2**2
	puts "Треугольник прямоугольный."
	puts "Треугольник равнобедренный." if c1 == c2
elsif c1 == c2 && c1 == g
	puts "Треугольник равнобедренный и равносторонний."
else
	puts "Треугольник не прямоугольный."
end