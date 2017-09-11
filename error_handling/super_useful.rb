# PHASE 2
def convert_to_int(str)
  Integer(str)
rescue ArgumentError => error
  puts error.message
  return nil
end

# PHASE 3
FRUITS = ["apple", "banana", "orange"]
class CoffeeError < StandardError
end


def reaction(maybe_fruit)
  if FRUITS.include? maybe_fruit
    puts "OMG, thanks so much for the #{maybe_fruit}!"
  elsif maybe_fruit == "coffee" || maybe_fruit == "Coffee"
    raise CoffeeError.new("Try Again, I love coffee")

  else
    raise StandardError
  end
end

def feed_me_a_fruit
  puts "Hello, I am a friendly monster. :)"

  puts "Feed me a fruit! (Enter the name of a fruit:)"
  maybe_fruit = gets.chomp
  reaction(maybe_fruit)
rescue CoffeeError => error
  puts error.message
  retry
rescue StandardError => error
  puts "That's not a fruit"


end

# PHASE 4
class FriendshipLengthError < StandardError
end
class NameLengthError < StandardError
end
class PasttimeError < StandardError
end


class BestFriend
  def initialize(name, yrs_known, fav_pastime)
    raise FriendshipLengthError.new("Maybe later...") if yrs_known < 5
    raise NameLengthError.new("you need a name") if name.empty?
    raise PasttimeError.new("pasttime must be something") if fav_pastime.empty?
    @name = name
    @yrs_known = yrs_known
    @fav_pastime = fav_pastime
  end

  def talk_about_friendship
    puts "Wowza, we've been friends for #{@yrs_known}. Let's be friends for another #{1000 * @yrs_known}."
  end

  def do_friendstuff
    puts "Hey bestie, let's go #{@fav_pastime}. Wait, why don't you choose. 😄"
  end

  def give_friendship_bracelet
    puts "Hey bestie, I made you a friendship bracelet. It says my name, #{@name}, so you never forget me."
  end
end
