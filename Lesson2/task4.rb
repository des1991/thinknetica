vowels = ['a', 'e', 'i', 'o', 'u', 'y']

vowels_with_index = {}

('a'..'z').to_a.each.with_index(1) do |letter, position|
  vowels_with_index[letter] = position if vowels.include? letter
end

puts vowels_with_index
