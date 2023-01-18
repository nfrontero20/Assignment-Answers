require 'rest-client'
require 'json'
require './utils.rb'
require './gene.rb'
require './interactionNetwork.rb'
require './report_creator.rb'

if ARGV.length() != 3 # A warning message in case the user makes a mistake when entering parameters
    abort "Run this using the command\n main.rb ArabidopsisSubNetwork_GeneList.txt [name of final report].txt [depth number]"
end


gene_list_txt, final_report, depth = ARGV

depth = depth.to_i

# Loading Genes
genes_list_names = Utils.read_txt(gene_list_txt)

genes_list = Array.new
genes_list_names.each do |gene_id|
    gene = Gene.new(id: gene_id, padre: nil, depth: depth)
    genes_list << gene
end

## CREATE A NEW CLASS

for gene in genes_list do
  new_net = InteractionNetwork.new(gene_id: gene.gene_id, depth: depth, all_list_genes: genes_list_names)
end

nets = new_net.all_networks()
nets.each do |net|
  puts net.genes_in_network # SHOWING THE GENES IN OUR ORIGINAL LIST THAT WILL INTERACT WITH EACH OTHER (FORMING NETWORKS)
  puts net.network  # SHOWING FULL NETWORKS, WHICH WILL CONTAIN BOTH THE ORIGINAL GENES IN OUR LIST, AS WELL AS THOSE THAT ARE OUTSIDE THE LIST
  puts '' # Printing an space between each Network found, to better visualize it in the terminal
end

write_report(final_report, nets, genes_list_names)