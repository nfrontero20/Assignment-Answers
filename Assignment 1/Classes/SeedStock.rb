#!/usr/bin/env ruby

# Require the date module
require 'date'

# Create new class called SeedStock
class SeedStock

    # Set attributes
    attr_accessor :seed_stock
    attr_accessor :gene_id
    attr_accessor :gene
    attr_accessor :last_planted
    attr_accessor :storage
    attr_accessor :grams_remaining

    @@all_seedstock = {}

    def initialize(params = {})
        @gene_id = params.fetch(:gene_id, nil)
        @gene = Gene.find_gene_by_id(@gene_id)
        # Make sure the gene attribute is a gene object in order for code to run
        unless @gene.is_a?(Gene) 
            abort("[ERROR:] #{@gene_id} not found in file: #{ARGV[0]}. Cannot match gene_id to gene object.")
        end
        @storage = params.fetch(:storage, nil)
        @seed_stock = params.fetch(:seed_stock, nil)
        @last_planted = params.fetch(:last_planted, nil)
        @grams_remaining = params.fetch(:grams_remaining, nil).to_i #And the remaining grams is, of course, a numeric value

    end


    def self.load_from_file(seedstock_file)
        # Read in the tsv file
        stock_table = CSV.read(seedstock_file, headers: true, col_sep: "\t") 
        # Save the headers so that we can use them to create a new file
        @stock_header = stock_table.headers 
        stock_table.each.with_index() do |row|
            # Create new instances of SeedStock class
            @@all_seedstock[row["Seed_Stock"]] =  SeedStock.new(:gene_id => row["Mutant_Gene_ID"], :storage => row["Storage"], :seed_stock => row["Seed_Stock"],
                                                                :last_planted => row["Last_Planted"], :grams_remaining => row["Grams_Remaining"])
        end
        # This hash contains all the seedstock
        return @@all_seedstock 
    end

    # Find a specific seedstock and extract the object from the hash
    def self.get_seed_stock(stock_ID) 
        @@all_seedstock.each do |stock|
            return stock[1] if stock[1].seed_stock == stock_ID
        end
    end

    # Planting
    def plant(number_of_grams) 
        # Seedstock too low, but above 0
        if @grams_remaining < number_of_grams
            puts "WARNING! #{@seed_stock} only has #{@grams_remaining} grams of seed :(.  Please refill with more seed soon so that I can plant the 7 grams as desired!"
            @grams_remaining = 0
        # Seedstock at 0
        elsif @grams_remaining == number_of_grams
            puts "WARNING! #{@seed_stock}'s seedstock is at 0.  Please refill with new seed :)."
            @grams_remaining = 0 #If there are 7 grams there'll be 0 left
        # Subtract 7 grams case
        else
            @grams_remaining = @grams_remaining - 7
        end
        @last_planted = DateTime.now.strftime('%-d/%-m/%Y') #Update date to today using the "Date" module
    end

    # Write out the new file
    def self.write_database(new_stock_file)
        new_table = File.open(new_stock_file, 'w')
        new_table.puts(@stock_header.join("\t"))
        @@all_seedstock.each do |this_stock|
            new_table.puts([this_stock[1].seed_stock, this_stock[1].gene_id, this_stock[1].last_planted, this_stock[1].storage, this_stock[1].grams_remaining].join("\t"))
        end
    end

end
