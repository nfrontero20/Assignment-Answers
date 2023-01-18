require 'rest-client'
require 'json'
require './utils.rb'

class InteractionNetwork

    attr_accessor :network              # Attribute corresponding to the hash that will contain all found networks
    attr_accessor :genes_in_network     # Attribute corresponding to all genes in our original list which will interact with each other, forming the networks
    attr_accessor :all_genes            # Attribute corresponding to all genes in our original list
    attr_accessor :kegg_pathway         # Attribute corresponding to the KEGG annotations of the genes of the networks
    attr_accessor :go_terms             # Attribute corresponding to the GO biological proccesses annotations of the genes of the networks
    @@all_networks = []                 # Class variable in which we are going to include valid networks (those that include 2 or more of the genes listed in our list)
    
    def initialize(params={})
      depth = params.fetch(:depth)
      gene_id = params.fetch(:gene_id)
      
      @network = Hash.new
      @genes_in_network = []
      @genes_in_network << gene_id
      @all_genes = params.fetch(:all_list_genes)
      
      search_Interaction(gene_id, depth) # Calling the search_Interaction function (defined below), which is the main function of this class.

      if genes_in_network.length() > 1  # If the network is formed by more than 1 gene, it appends to the array defined by the class variable: @@all_networks
        @@all_networks << self
      end
      
      network_in_array = @network.keys | @network.values.flatten.uniq  
      @kegg_pathway = get_kegg(ids=network_in_array)    #get KEGG pathways annotation of all the genes which form networks
      @go_terms = get_go_terms(ids=network_in_array)    #get GO biological processes annotation of all the genes which form networks
      
    end
    

    def search_Interaction(gene_id, depth) #MAIN FUNCTION OF THIS CLASS

      res = Utils.fetch ("http://www.ebi.ac.uk/Tools/webservices/psicquic/intact/webservices/current/search/interactor/#{gene_id}?species:3702?format=tab25")
      if res
        lines = res.body.split("\n")
        
        # Iteration of lines from eb
        
        lines.each do |i|
          line_splitted = i.split("\t")
          p1_locus = line_splitted[4] # Selecting the 5th element
          p2_locus = line_splitted[5] # Selecting the 6th element
          score = line_splitted[14]   # Selecting the 15th element
          
          intact_miscore = score.sub(/intact-miscore:/, "").to_f # Extracting the miscore number
          
          # Applying some filters
          p1_locus = p1_locus.match(/A[Tt]\d[Gg]\d{5}/).to_s.upcase # Filter 1: Applying a regular expression to match the Locus code
          if p1_locus == ""
            next
          else
            g1 = p1_locus
          end
         
          p2_locus = p2_locus.match(/A[Tt]\d[Gg]\d{5}/).to_s.upcase # Filter 1: Applying a regular expression to match the Locus code
          if p2_locus == ""
            next
          else
            g2 = p2_locus
          end
          #puts ""
          
          if g1.upcase != gene_id.upcase # Filter 2: Some gene positions in intact are swapped, we need to fix it
                g1, g2 = g2, g1
          end
          
          if g1 == g2 or g2 == "" #Filter 3: We must take into account that they could iterate with themselves, or with a non-arabidopsis gene
            next
          end
          
          if intact_miscore < 0.485 #Filter 4: When the miscore is lower than 0.485, this value was taken from the literature: ncbi.nlm.nih.gov/pmc/articles/PMC4316181/
            next
          end
          # END OF FILTERS          
          
          # Checking if it can be saved into the hash
          if @network.keys.include?(g2)     # g2 already exists on the network?
            # if it already exists
            if @network[g2].include?(g1)    # g2 already has a relationship with g1?
                next
            end
          end
          
          # Checking if it can be saved into the hash
          if @network.keys.include?(g1)     # g1 already exists on the network? 
            # if it already exists
            if @network[g1].include?(g2)    # g1 already has a relationship with g2?
              next
            end
            
            checking_listed(g2)
            @network[g1] << g2 # Append to the g1 array
          else
            
            checking_listed(g2)
            @network[g1] = [g2]
          end
          
          # Should I keep looking for? (DEPTH)
          if depth > 1
            # Keep going with one less depth
            search_Interaction(g2, depth-1) 
          end
          if depth == 0
            next
          end

        end
        # End of iteration
        
      else
          puts "Error with: #{@gene_id}" # An error message just in case any iteration fails
      end
        
    end
 
    def checking_listed(new_gen_id) # Defining a new function, which will append any gene that is found in the network if it belongs to the original gene list
        if @all_genes.include?(new_gen_id)
            @genes_in_network |= [new_gen_id]
        end
    end
    
    def all_networks
      return @@all_networks
    end
    
    def get_kegg(genes_id) # Defining the function that will look for any KEGG Pathways the interaction network members are part of
        result = []
        genes_id.each do |id|
            res = Utils.fetch ("http://togows.org/entry/genes/ath:#{id}/pathways.json")
            if res
                response = JSON.parse(res.body)[0]
                response.each do |kegg_id,kegg_p|
                   result << [kegg_id,kegg_p] 
                end
                
            end
            return result  
        end
    end

    
    def get_go_terms(genes_id) # Defining the function that will look for any GO Terms associated with the total of all genes in the network
        result = []
        genes_id.each do |id|
            res = Utils.fetch ("http://togows.org/entry/uniprot/#{id}/dr.json")
            if res
                response = JSON.parse(res.body)[0]
                response['GO'].each do |go|
                    if go[1].start_with?('P:')
                        result << [go[0], go[1].slice(2..-1)] 
                    end
                
                end
                
            end
            return result.uniq # Removing duplicate values in an array 
        end
    end
    
end