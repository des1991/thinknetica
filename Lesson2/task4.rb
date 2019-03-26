vowels = ['a', 'e', 'i', 'o', 'u', 'y']
index = 1

vowels_with_index = Hash.new

for letter in 'a'..'z'
  vowels_with_index[letter] = index if vowels.include? letter
  index += 1
end

puts vowels_with_index
