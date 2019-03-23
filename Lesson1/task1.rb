print "Как Вас зовут? "
name = gets.chomp.capitalize

print "Укажите Ваш рост: "
tall = gets.chomp.to_i - 100

if tall < 0
	puts "#{name}, Ваш вес уже оптимальный"
else
	puts "#{name}, Ваш идеальный вес #{tall}"
end