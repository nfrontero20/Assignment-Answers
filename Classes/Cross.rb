#!/usr/bin/env ruby

# Create Cross class
class Cross
    # Create attributes
    attr_accessor :parent1
    attr_accessor :parent2
    attr_accessor :f2_wild
    attr_accessor :f2_p1
    attr_accessor :f2_p2
    attr_accessor :f2_p1p2

    # Recall @@ indicates class variables
    @@all_crosses = {}

    # Initialize parameters
    def initialize(params = {})
        # These are the column names from the cross_data tsv file
        @parent1 = SeedStock.get_seed_stock(params.fetch(:parent1)).gene
        @parent2 = SeedStock.get_seed_stock(params.fetch(:parent2)).gene
        @f2_wild = params.fetch(:f2_wild, nil).to_f
        @f2_p1 = params.fetch(:f2_p1, nil).to_f
        @f2_p2 = params.fetch(:f2_p2, nil).to_f
        @f2_p1p2 = params.fetch(:f2_p1p2, nil).to_f

    end

    # Define a method
    def self.load_from_file(crossdata_file)
        # Read CSV and set to be crossdata_table
        # Header is set to true, columns are separated by tabs
        crossdata_table = CSV.read(crossdata_file, headers: true, col_sep: "\t")
        crossdata_table.each.with_index() do |row|
            # Name each object 
            @@all_crosses[row["Parent1"]+"_"+row["Parent2"]] =  Cross.new(:parent1 => row["Parent1"], :parent2 => row["Parent2"],
                                                                          :f2_wild => row["F2_Wild"], :f2_p1 => row["F2_P1"],
                                                                          :f2_p2 => row["F2_P2"], :f2_p1p2 => row["F2_P1P2"])
        end
        return @@all_crosses
    end

    # Define a method
    def self.analyze_linkage(cross_object)

        # Chi-squared test: 
        # Used to "examine whether two categorical variables are independent in influencing the test statistic" (meaning, the values within the table)
        # (Citation: https://en.wikipedia.org/wiki/Chi-squared_test)
        
        # Sum all the values
        sum_row = cross_object.f2_wild + cross_object.f2_p1 + cross_object.f2_p2 + cross_object.f2_p1p2
        
        # Get the expected values of each row
        expected_wild = sum_row * 9/16 
        expected_f2_p1 = sum_row * 3/16
        expected_f2_p2 = sum_row * 3/16
        expected_f2_p1p2 = sum_row * 1/16

        # Calculate chi squared
        chi_squared = ( (cross_object.f2_wild - expected_wild)**2/expected_wild  +
                        (cross_object.f2_p1 - expected_f2_p1)**2/expected_f2_p1 +
                        (cross_object.f2_p2 - expected_f2_p2)**2/expected_f2_p2 +
                        (cross_object.f2_p1p2 - expected_f2_p1p2)**2/expected_f2_p1p2 )

        # Check for correlation
        # Set threshold to be 99% probability of correlation
        # The chi squared value for a p of 0.01 with 3 degrees of freedom is 11.34 (according to a probability table) 
        # (Citation: https://online.stat.psu.edu/stat414/lesson/15/15.9) 
        if chi_squared > 11.34
            puts "Match Found! #{cross_object.parent1.gene_name} is linked to #{cross_object.parent2.gene_name} with a chi-square score of #{chi_squared}"
            cross_object.parent1.add_linked_gene(cross_object.parent2.gene_name, chi_squared) #Adds the linkage to the linked_genes attribute
            cross_object.parent2.add_linked_gene(cross_object.parent1.gene_name, chi_squared)
        end
    end


end