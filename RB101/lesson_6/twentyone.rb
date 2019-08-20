require 'pry'
DECK = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "jack", "king", "queen", "ace"]
SUITS = %w(hearts diamonds clubs spades)

def prompt(msg)
  puts "=> #{msg}"
end

def generate(cards)
  cards = []
  cards << DECK.sample(1) + SUITS.sample(1)
  cards << DECK.sample(1) + SUITS.sample(1)
end

def total(gamecards)
  values = gamecards.map { |card| card[0] }
  sum = 0
  values.each do |value|
    if value == "jack" || value == "king" || value == "queen"
      sum += 10 if sum != 21
    else
      sum += value.to_i
    end
    if value == "ace" && sum >= 20
      sum += 1
    elsif value == "ace" && sum < 20
      sum += 11 if sum != 21
    end
  end
  sum
end

def format_string(array)
  string = ''
  array.each do |element|
    string << "#{element[0]}, "
  end
  string.slice(0..-3)
end

def player_busted?(cards)
  total(cards) >= 21
end

def dealer_busted?(cards)
  total(cards) >= 17
end

def dealer_result(cards)
  if !!dealer_busted?(cards)
    prompt "Dealer's a bust. Player wins."
  end
end

def player_result(cards)
  if !!player_busted?(cards)
    prompt "Player's a bust. Dealer wins."
  end
end


def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  answer.downcase.start_with?('y')
end

prompt "Welcome to Twenty One!"
player_cards = []
player_cards = generate(player_cards)
prompt "You have #{player_cards[0][0]} and #{player_cards[1][0]}."

dealer_cards = []
dealer_cards = generate(dealer_cards)
prompt "Dealer has #{dealer_cards[0][0]} and unknown card."
player_answer = ''
loop do
  dealer_total = total(dealer_cards)
  player_total = total(player_cards)
  loop do
    prompt "Player, hit or stay?"
    player_answer = gets.chomp
    system "clear"
    break if player_answer == "hit" || player_answer == "stay"
    prompt "Please enter a correct option: hit or stay."
  end
  if player_answer == "hit"
    player_cards << DECK.sample(1) + SUITS.sample(1)
    prompt "You now have #{format_string(player_cards)}."
    if !!player_busted?(player_cards)
      player_result(player_cards)
      break unless play_again?
    end
  elsif player_answer == "stay" && dealer_total <= 17
    prompt "Dealer will play now..."
    Kernel.sleep(1)
    dealer_cards << DECK.sample(1) + SUITS.sample(1)
    if !!dealer_busted?(dealer_cards)
      dealer_result(dealer_cards)
      break unless play_again?
    end
  elsif dealer_total > 17 && player_answer == "stay"
    prompt "Dealer stayed."
    if dealer_total > player_total
      prompt "Dealer's total #{dealer_total} is higher."
    else
      prompt "Player's total is higher."
    end
    break
  end
end
prompt "Thank you for playing Twenty One! Goodbye!"

