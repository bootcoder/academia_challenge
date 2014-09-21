
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



require "awesome_print"

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
		@interest_hash.each { |item| ap "ID: #{item[0]} -- #{item[1]}" }
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
			puts "#{id1} <--> #{id2}"
			puts "weight: #{result[2]}"
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
			break if check == "break"
		end
	end

	def count_interest
		checked_hash = Hash.new(0)
		@weights_array.each do |item|
			checked_hash[item[0]] += 1
		end

		for i in 0..checked_hash.values.max
			checked_hash.each do |item| 
				if checked_hash[item[0]] == i 
					puts "#{id_to_interest(item[0])}" 
					@print_num = true
					break
				else
					@print_num = false
				end
			end
			puts "Relations Count: #{i}\n\n" if @print_num == true
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
		search_interests(id) if more.include? "yes"
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

	def sort_relations
		ap @weights_array
		top = @weights_array.sort {|a,b| b[2] <=> a[2]}
		bottom = @weights_array.sort {|a,b| a[2] <=> b[2]}

		puts "Top Relations are:"
		convert_results(top[0..10])
		puts "Lowest Relations are:"
		convert_results(bottom[0..10])
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
		input = gets.chomp.downcase
		system 'clear'
		case input
			when "help"
				puts "Commands include:"
				puts "List: To list all interests."
				puts "Search: To return a specific interest or id."
				puts "Analysis: To see all relations."
				puts "Count: To see relations counts of all interests."
				get_input
			when "list"
				@academia.list_intersts
				get_input
			when "search"
				@academia.list_intersts
				puts @academia.user_input
				get_input
			when "analysis"
				@academia.analyse_interest
				get_input
			when "count"
				@academia.count_interest
				get_input
			when "relations"
				@academia.sort_relations
				get_input
			when "exit"
				puts "Bye Bye Apple Pie"
			else
				puts "Unrecognized Input: Please try again"
				get_input
		end
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
