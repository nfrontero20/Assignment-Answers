#!/usr/bin/env ruby


### Requirements 


require './Classes/Gene.rb'
require './Classes/SeedStock.rb'
require './Classes/Cross.rb'


### Presentation

puts "Hello. Let's get started."
puts "Let me first check the inputs."

### Check the inputs

# Make sure you get 4 arguments
if ARGV.length() != 4
    abort("ERROR! Wrong input format.")
else
    # Run a check to see if the new_stock_file exists
    ARGV.each_with_index() do |file_argv, index|
        if index == 3
            if File.file?(file_argv) == true
                printf "WARNING! The specified output file ( #{file_argv} ) already exists.  If you wish to delete, type yes"
                prompt = STDIN.gets.chomp
                if ( prompt == "y" or prompt == "Y" or prompt == "Yes" or prompt == "yes" )
                    File.delete(file_argv)
                else
                    # Abort if no valid file is provided
                    abort("ERROR: The specified output file: #{file_argv} already exists, so specificy another one.")
                end
            else
                puts "Looks good to go!"
            end
        # Give a warning if no file exists
        elsif File.file?(file_argv) == false
            abort("WARNING! The specified file: #{file_argv} does not exist.")
        end
    end

end

puts


### Planting

puts "Time to plant some seeds, which can take some time..."
sleep 1

# Load the Gene file
all_genes = Gene.load_from_file(ARGV[0])

# Load seedstock file
all_seedstock = SeedStock.load_from_file(ARGV[1])

# Plant 7 seeds for each seedstock item 
all_seedstock.each do |this_seed|
    this_seed[1].plant(7) 
end

#Re-generate database
SeedStock.write_database(ARGV[3])
puts


### Correlation 

puts "Let's analyze whether the genes are correlated" 
sleep 1
puts "Here's your results!"
puts


# Load crosses table and generate hashes
all_crosses = Cross.load_from_file(ARGV[2])

# Analyze the links
all_crosses.each do |this_cross|
    Cross.analyze_linkage(this_cross[1])
end


### Final Report 


puts
puts "Final Report:"
sleep 1
puts

all_genes.each do |this_gene|
    this_gene[1].linked_genes.each do |linked|
        linked_gene, chi_squared = linked 
        puts "#{this_gene[1].gene_name} is linked to #{linked_gene}"
    end
end

