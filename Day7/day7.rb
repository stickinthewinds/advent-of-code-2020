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

  # { outer bag => {int => inner bag}}
  def read_file
    bags = {}
    line_num=0
    text=File.open(ARGV[0]).read
    text.each_line do |line|
      bag_type = line.split(' bags contain')
      if bag_type[1] != " no other bags.\n"
        bags = read_inner_bags(bags, bag_type, line)
        #puts "#{line_num += 1} #{inner_bags}\n"
      else
        bags[bag_type[0]] = {"None" => 0}
      end
    end

    gold_count = 0
    looked = {}
    #puts "#{bags.length}"
    bags.each do |k, v|
      gold_count = count_gold_bags(looked, bags, k, 1)
    end
    puts "#{gold_count}"
  end

  def read_inner_bags(bags, outer_bag, line)
    inner_bags = outer_bag[1].split(',')
    for bag in inner_bags
      num_bags = bag[/\d+/].to_i
      bag_colour = bag[/[a-zA-Z]+ [a-zA-Z]+/]
      #puts "#{outer_bag[0]} #{num_bags} #{bag_colour}\n"
    end
    bags[outer_bag[0]] = {bag_colour => num_bags}
    return bags
  end

  def count_gold_bags(looked, bags, key, depth)
    # If it has been checked don't bother checking again
    if looked.include? key
      # If it is above one return the depth to the key
      # Otherwise return the key as is
      value = looked[key]
      return value > 1 ? value + depth : value
    end

    # Since it does not exist initialise it at 0
    looked[key] = 0

    # For each inner bag check if it is shiny gold.
    # If not and it is not an empty bag then repeat
    bags[key].each do |k, v|
      puts "#{key}, #{k}, #{v}"
      # If the bag contains a golden bag return the current depth
      if k == "shiny gold" and v > 0
        puts "Found one"
        looked[key] += depth - 1
      elsif k != "None"
        looked[key] = count_gold_bags(looked, bags, k, depth + 1)
      end
    end
    return looked.values.inject { |a, b| a + b }
  end

  day7 = Day7.new
  day7.start_program
