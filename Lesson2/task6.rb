cart = Hash.new
cart_sum = 0

loop do
  print "Название товара: "
  product_name = gets.chomp

  break if product_name == "стоп"

  print "Цена: "
  product_price = gets.to_f

  print "Кол-во: "
  product_amount = gets.to_f

  cart[product_name] = {
    price: product_price,
    amount: product_amount,
    sum: product_price * product_amount
  }
end



cart.each_value { |product| cart_sum += product[:sum] }

puts cart_sum
