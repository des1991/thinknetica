nums = []

for num in 10..100
  nums << num if num % 5 == 0
end

puts nums
