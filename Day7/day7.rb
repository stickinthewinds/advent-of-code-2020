#!/usr/bin/env ruby

class Day7
    def start_program
        if ARGV.length != 1
            puts "Must contain exactly one input file argument."
            exit
        end

        read_file
    end
  end

  # { outer bag => [{int => inner bag}, {int => inner bag}]}
  def read_file
    bags = {}
    line_num=0
    text=File.open(ARGV[0]).read

    text.each_line do |line|
      bag_type = line.split(' bags contain')
      bags[bag_type[0]] = []
      if bag_type[1] != " no other bags.\n"
        bags = read_inner_bags(bags, bag_type, line)
      else
        bags[bag_type[0]].push(["None", 0])
      end
    end

    looked = {}
    #puts "#{bags.length}"
    bags.each do |k, v|
      check_gold_bags(looked, bags, k)
    end

    puts "#{looked.values.count(true)}"
    part2(bags)
  end

  def read_inner_bags(bags, outer_bag, line)
    inner_bags = outer_bag[1].split(',')
    for bag in inner_bags
      num_bags = bag[/\d+/].to_i
      bag_colour = bag[/[a-zA-Z]+ [a-zA-Z]+/]
      #puts "#{outer_bag[0]} #{num_bags} #{bag_colour}\n"
      bags[outer_bag[0]].push([bag_colour, num_bags])
    end
    #bags[outer_bag[0]] = {bag_colour => num_bags}
    return bags
  end

  def check_gold_bags(looked, bags, key)
    # If it has been checked don't bother checking again
    if looked.include? key
      return looked[key]
    end

    # Since it does not exist initialise it as false
    looked[key] = false

    # For each inner bag check if it is shiny gold.
    # If not and it is not an empty bag then repeat
    puts "#{key}: #{bags[key]}"
    inner_bags = bags[key]
    for bag in inner_bags
      # If the bag contains a golden bag set the current bag to true
      if bag[0] == "shiny gold" and bag[1] > 0
        looked[bag[0]] = false # Shiny gold bag doesn't count
        looked[key] = true
      elsif bag[0] != "None"
        lookDown = check_gold_bags(looked, bags, bag[0])
        looked[key] = looked[key] ?
                true :
                lookDown
      end
    end

    return looked[key]
  end

  def part2(bags)
    looked = {}
    total = part2_recurse("shiny gold", bags, looked)
    puts "Total: #{total}"
  end

  # recursively count the bags inside of the given bag_type
  def part2_recurse(bag_type, bags, looked)
    if looked.include? bag_type
      return looked[bag_type]
    end

    if (bag_type == "None")
      looked[bag_type] = 1
      return 1
    else
      total = 0
      for bag in bags[bag_type]
        #puts "Adding #{bag[1]} bags of #{bag[0]} to #{bag_type}"
        total += bag[1] + (bag[1] * part2_recurse(bag[0], bags, looked))
      end
      puts "Total for #{bag_type}: #{total}"
      looked[bag_type] = total
      return total
    end
  end

  day7 = Day7.new
  day7.start_program
