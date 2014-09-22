
# Parsing Section

# bring in two files
# parse one to a hash of interests and codes
# parse into an array of codes and weights


# sorting Section

	# INTERESTS

	# write a method to return a code for an interest
	# write a method to return a interest for a code

	# WEIGHTED
	# write a method to return all codes from arrays with matching code as passed
	# bonus to return weight 



# require "awesome_print"

###################
# MAIN Class
###################

class Parser

	attr_accessor :interest_hash, :weights_array

	def initialize(args = {})
		@interest_hash
		@weights_array
	end

	def parseInterests(file)
		@interest_hash = Hash.new
		File.readlines(file).each_with_index do |line, index|
			line.gsub!("\n", "") if line.include? "\n"
			items = line.split("\t")
			@interest_hash[items[0]] = items[1] unless index == 0
		end
		@interest_hash
	end

	def parseWeights(file)
		@weights_array = []
		File.readlines(file).each_with_index do |line, index|
			line.gsub!("\n", "") if line.include? "\n"
			@weights_array << line.split("\t") unless index == 0
			
		end
		@weights_array
	end
	

###################
# search interests
###################


	def id_to_interest(id)
		@interest_hash[id]
	end

	def interest_to_id(interest)
		id = @interest_hash.select do |k,v|
			k if v.downcase == interest.downcase
		end
		id.keys[0]
	end

	def search_list(input)

	end

	def list_intersts
		sorted =  @interest_hash.sort { |a,b| a[1] <=> b[1]}
		# ap sorted
		sorted.each { |item| printf "%-20s %s\n", "ID: #{item[0]}", "#{item[1]}"}
	end
	
###################
# search weights
###################

	def search_interests(id)
		results = []
		@weights_array.each_with_index do |item, index|
			results << item if item[0] == id || item[1] == id
		end
		convert_results(results)
	end

	def convert_results(results_arr)
		sorted = results_arr.sort { |a,b| a[2] <=> b[2]}
		sorted.each do |result|
			id1 = id_to_interest(result[0])
			id2 = id_to_interest(result[1])
			puts "*"*100
			printf "%-20s %s\n","Weight: #{result[2]}  --- ", "#{id1} <--> #{id2}"
			puts "*"*100
			puts 
			puts
		end
		puts "End Of Record -- Enter to Proceed, Break to exit (if available)"
	end

	def analyse_interest
		checked_array = []
		@weights_array.each do |item|
			search_interests(item[0]) unless checked_array.include? item[0]
			checked_array << item[0]
			check = gets.chomp.downcase
			system 'clear'
			break if check == "break"
		end
	end

	def count_interest
		checked_hash = Hash.new(0)
		@weights_array.each do |item|
			checked_hash[item[0]] += 1
		end

		# ap checked_hash

		for i in 0..checked_hash.values.max
			checked_hash.each do |item|
				if checked_hash[item[0]] == i 
					printf "%-20s %s\n", "Relations: #{i}", "#{id_to_interest(item[0])}"
					@print_num = true
				else
					@print_num = false
				end
			end
		end
	end

	def count_relations(id)
		checked_hash = Hash.new(0)
		
		@weights_array.each do |item|
			checked_hash[item[0]] += 1
			checked_hash[item[1]] += 1
		end

		puts "#{id_to_interest(id)} has #{checked_hash[id]} relations"
		puts "Would you like to see related records? (yes or no)"
		more = gets.chomp.downcase
		search_interests(id) if more.include? "y"
	end

	def user_input
		puts "Enter an ID or a subject:"
		input = gets.chomp.downcase
		result_id = interest_to_id(input)
		result_int = id_to_interest(input)
		@result = ""
		if result_id
			@result = result_id
		elsif result_int
			@result = interest_to_id(result_int)
		else
			puts "NO RECORD FOUND"
		end
		puts
		puts "Record Found: #{id_to_interest(@result)}"
		puts
		count_relations(@result)
		
	end

	def sort_relations(num, position)
		top = @weights_array.sort {|a,b| b[2].to_i <=> a[2].to_i}
		bottom = @weights_array.sort_by {|a| a[2]}
		if position.include? "top"
			puts
			puts "******************"
			puts "Top Relations:"
			puts "******************"
			puts
			convert_results(top[0..num.to_i])
			puts
		elsif position.include? "b"
			puts
			puts "*********************"
			puts "Lowest Relations:"
			puts "*********************"
			puts
			convert_results(bottom[0..num.to_i])
			puts
		end
	end

	def sort_weights
		weights = []
		@weights_array.each do |item|
			weights << item[2]
		end
		puts weights
		puts weights.min
		puts weights.max
	end




end






###################
# Control Code
###################

def runAPP

	@academia = Parser.new
	@academia.parseInterests("interest.txt")
	@academia.parseWeights("weight.txt")
	
	system'clear'
	puts
	puts "Welcome to the Acedemia.edu JR data cruncher"

	def get_input
		puts
		puts
		puts "Main Menu: Please enter a command || Help"
		display_commands
		prompt
		input = gets.chomp.downcase
		system 'clear'
		case input
			when "help"
				display_commands
				get_input
			when "list", "1"
				@academia.list_intersts
				get_input
			when "search", "2"
				@academia.list_intersts
				puts @academia.user_input
				get_input
			when "analysis", "3"
				@academia.analyse_interest
				get_input
			when "count", "4"
				@academia.count_interest
				get_input
			when "relations", "5"
				print "Please enter the number of results you would like: "
				prompt
				num = gets.chomp.downcase
				print "Top or Bottom?"
				prompt
				list_input = gets.chomp.downcase
				@academia.sort_relations(num, list_input)
				get_input
			when "sort"
				@academia.sort_weights
				get_input
			when "exit", "6"
				puts "Bye Bye Apple Pie"
			else
				puts "Unrecognized Input: Please try again"
				get_input
		end
	end

	def display_commands
		puts "Commands include:"
		puts "1. List -- To list all interests."
		puts "2. Search -- To return a specific interest or id."
		puts "3. Analysis -- To see all relations."
		puts "4. Count -- To see relations counts of all interests."
		puts "5. Relations -- To see Top and Bottom relations."
		puts "6. Exit"
	end

	def prompt
		print ">"
	end
	get_input
end


# academia.id_to_interest("3637")
# academia.interest_to_id("Advertising")

# academia.search_interests("48")

# academia.list_intersts
# academia.analyse_interest
# academia.count_interest


runAPP
