#!/usr/bin/env ruby

# Require a CSV file
require 'csv'

# Create the Gene class
class Gene
    # Create attributes
    attr_accessor :gene_id
    attr_accessor :gene_name
    attr_accessor :mutant_phenotype
    attr_accessor :linked_genes

    # Recall @@ indicates class variables
    @@all_genes = {}

    # Initialize parameters
    def initialize(params = {})
        #Variable assignments have to go here in case I need to print them in the abort message
        @gene_id = params.fetch(:gene_id, nil)
        @gene_name = params.fetch(:gene_name, nil)
        @mutant_phenotype = params.fetch(:mutant_phenotype, nil)
        # Create hash
        @linked_genes = {}

        # Regex
        format_gene = /A[Tt]\d[Gg]\d\d\d\d\d/ 

        # If the gene format is wrong, print an abort message
        unless format_gene.match(@gene_id) 
            abort("ERROR: Wrong gene ID format #{@gene_id}")
        end
    end

    # Use the ID to find the gene
    def self.find_gene_by_id(id) 
        @@all_genes.each do |gene|
            return gene[1] if gene[1].gene_id == id
        end
    end

    # Read in data
    def self.load_from_file(gene_table_file)
        # Read CSV and set to be gene_table
        # Header is set to true, columns are separated by tabs
        gene_table = CSV.read(gene_table_file, headers: true, col_sep: "\t") 
        
        # For each row in the table, create a new instance of class Gene
        gene_table.each() do |row|
            @@all_genes[row["Gene_ID"]] =  Gene.new(:gene_id => row["Gene_ID"], :gene_name => row["Gene_name"], :mutant_phenotype => row["mutant_phenotype"])
        end
        return @@all_genes    
    end

    def add_linked_gene(gene, chi_squared) 
        @linked_genes[gene] = chi_squared
    end

end
