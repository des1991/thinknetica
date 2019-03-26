print "Введите дату (дд.мм.гггг): "
date = gets.chomp
date_split = date.split('.')

day = date_split[0].to_i
month = date_split[1].to_i
year = date_split[2].to_i

days_in_months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

day_num = day

month.times do |num|
  day_num += days_in_months[num] if num < month-1
end

if month > 2 && (
  (year % 4 == 0 && year % 100 != 0) || 
  (year % 4 == 0 && year % 100 == 0 && year % 400 ==0)
  )
    day_num += 1
end

puts day_num
