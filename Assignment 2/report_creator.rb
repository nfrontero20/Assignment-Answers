require './utils.rb'
require './gene.rb'
require './interactionNetwork.rb'

def write_report(final_report, all_networks, gene_txt)
  

  # REPORT CREATION
  
  File.open(final_report, 'w+') do |f| 
    f.puts("Report file of possible interactions between predicted co-expressed genes:")
    f.puts("")
    f.puts("Number of genes analysed (from the original txt): #{gene_txt.length()}. \n ")
    f.puts("#{all_networks.length()} networks involving genes in our original list have been detected. \n ")
    f.puts("The depth of the analysis is chosen by the user. \n \n ")
    all_networks.each do |net|
      f.puts "Genes from the original list which interact with each other (directly and/or indirectly) and form a network: #{net.genes_in_network.join(', ')} \n " # SHOWING THE GENES IN OUR ORIGINAL LIST THAT WILL INTERACT WITH EACH OTHER (FORMING NETWORKS)
      f.puts "Complete network, including both the genes in the list (above) and other interactions with genes outside the list: \n "
      net.network.each do |key, value| # SHOWING FULL NETWORKS, WHICH WILL CONTAIN BOTH THE ORIGINAL GENES IN OUR LIST, AS WELL AS THOSE THAT ARE OUTSIDE THE LIST
          f.puts "#{key} has the following connections: #{value.join(', ')}" 
      end
      
      if net.kegg_pathway[0] != nil
        f.puts("\n\nThe following pathways have been found in KEGG for genes in this network:")

          net.kegg_pathway.each do |path|
            f.puts("\n-KEGG ID: #{path[0]} with pathway name: #{path[1]}")
          end
      else
        f.puts("\nNo pathways have been found in KEGG for the genes in this network.")
      end
      
      if net.go_terms[0] != nil
        f.puts("\n\nThe biological process terms from Gene Ontology associated with these genes are:")

          net.go_terms.each do |go|
            f.puts("\n-GO ID: #{go[0]} with term: #{go[1]}")
          end
      else
        f.puts("\nNo terms have been found in Gene Ontology for the genes in this network.")
      end
      
      f.puts "" # Printing an space between each Network found, to better visualize it in the terminal
      f.puts '_______________________________________________________________________________________________________'
      f.puts "" # Printing an space between each Network found, to better visualize it in the terminal
        
    end
    
  end
end