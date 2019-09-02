VALUES = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "jack", "king", "queen", "ace"]
SUITS = %w(hearts diamonds clubs spades)
TOURNAMENT_MAX = 5
PLAYER_MAX = 21
DEALER_MAX = 17

def prompt(msg)
  puts "=> #{msg}"
end

def initialize_deck
  SUITS.product(VALUES).shuffle
end

def total(gamecards)
  values = gamecards.map { |card| card[1] }
  sum = 0
  values.each do |value|
    if value.to_s == "ace"
      sum += 11
    elsif value.to_i == 0
      sum += 10
    else
      sum += value.to_i
    end
  end
  values.select { |value| value == "ace" }.count.times do
    sum -= 10 if sum > PLAYER_MAX
  end
  sum
end

def display_cards(hand)
  string = ''
  hand.each do |element|
    string << "#{element[1]} of #{element[0]}, "
  end
  string.slice(0..-3)
end

def ask_player
  puts "---------------------"
  prompt "Player, hit or stay?"
  gets.chomp
end

def busted?(cards)
  total(cards) > PLAYER_MAX
end

def dealer_result(cards)
  if !!busted?(cards)
    prompt "Dealer's a bust. You win."
  end
end

def player_result(cards)
  if !!busted?(cards)
    prompt "You're a bust. Dealer wins."
  end
end

def play_again?
  puts "-------------"
  prompt "Do you want to play again? (y or n)"
  answer = gets.chomp
  system "clear"
  answer.downcase == 'y'
end

def wait_btwn_rounds
  prompt "Starting new game in 5..."
  Kernel.sleep(1)
  prompt "Starting new game in 4..."
  Kernel.sleep(1)
  prompt "Starting new game in 3..."
  Kernel.sleep(1)
  prompt "Starting new game in 2..."
  Kernel.sleep(1)
  prompt "Starting new game in 1..."
  Kernel.sleep(1)
end

def display_stay(cards)
  total(cards)
  prompt "Stayed at #{total(cards)}"
end

def display_dealer
  prompt "Dealer will play now..."
  Kernel.sleep(1)
end

def scoring
  player_wins = ''
  dealer_wins = ''
  if player_wins > dealer_wins
    prompt "Player won!"
  else
    prompt "Dealer won!"
  end
end

player_wins = 0
dealer_wins = 0

loop do
  prompt "Welcome to Twenty One!"
  prompt "This tournament is best of five games."
  deck = initialize_deck
  player_cards = []
  dealer_cards = []
  2.times do
    player_cards << deck.pop
    dealer_cards << deck.pop
  end

  puts "---------------------"
  prompt "You have #{display_cards(player_cards)}"
  prompt "Dealer has #{dealer_cards[0][1]} of #{dealer_cards[0][0]}."
  prompt "Dealer has an unknown card."

  loop do
    player_answer = ''
    loop do
      player_answer = ask_player
      break if player_answer == "hit" || player_answer == "stay"
      prompt "Please enter a correct option: hit or stay."
    end
    system "clear"
    player_cards << deck.pop if player_answer == "hit"
    prompt "You now have #{display_cards(player_cards)}."
    break if busted?(player_cards) || player_answer == "stay"
  end

  if busted?(player_cards)
    player_result(player_cards)
    dealer_wins += 1
  else
    display_stay(player_cards)
  end

  until busted?(player_cards) || busted?(dealer_cards)
    display_dealer
    dealer_cards << deck.pop
    prompt "Dealer has #{display_cards(dealer_cards)}."
    if busted?(dealer_cards)
      player_wins += 1
      dealer_result(dealer_cards)
    else
      display_stay(dealer_cards)
    end
  end

  dealer_total = total(dealer_cards)
  player_total = total(player_cards)

  puts "------------------"
  prompt "You had #{display_cards(player_cards)} equal to #{player_total}"
  prompt "Dealer had #{display_cards(dealer_cards)} equal to #{dealer_total}"
  puts "--------------"
  prompt "Player's tournament score is #{player_wins}"
  prompt "Dealer's tournament score is #{dealer_wins}"
  puts "------------------"
  prompt "Press enter to start a new round."
  gets.chomp
  wait_btwn_rounds

  if player_wins == TOURNAMENT_MAX || dealer_wins == TOURNAMENT_MAX
    prompt "#{TOURNAMENT_MAX} wins. Game over."
    scoring
    break unless play_again?
    player_wins = 0
    dealer_wins = 0
  end
  system "clear"
end
prompt "Thank you for playing Twenty One! Good bye."
