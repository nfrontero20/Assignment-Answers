require 'rest-client'
require 'json'
require './utils.rb'
require  './gene.rb'
require  './interactionNetwork.rb'

def test_fetch()
  res = Utils.fetch("http://www.ebi.ac.uk/Tools/webservices/psicquic/intact/webservices/current/search/interactor/At3g54340?species:3702?format=xml25")

  puts res
  
  if res  # res is either the response object (RestClient::Response), or false, so you can test it with 'if'
    body = res.body  # get the "body" of the response
  else
    puts "the Web call failed - see STDERR for details..."
  end
end

def test_gene()  
  genes_list_names = read_txt("ArabidopsisSubNetwork_GeneList.txt")
  genes_list = Array.new
  genes_list_names.each do |gene_id|
      gene = Gene.new(id: gene_id)
      genes_list << gene
  end
  
  genes_list.each do |gene|
    puts gene.gene_id
  end
end

# UP TO HERE TESTS

depth = 2   # SELECTING THE DEPTH

# Loading genes
genes_list_names = read_txt("short_tests.txt")

genes_list = Array.new
genes_list_names.each do |gene_id|
    gene = Gene.new(id: gene_id, padre: nil, depth: depth)
    genes_list << gene
end

for gene in genes_list do
  new_net = InteractionNetwork.new(gene_id: gene.gene_id, depth: depth, all_list_genes: genes_list_names)
end

nets = new_net.all_networks()
nets.each do |net|
  puts net.genes_in_network # Showing the genes in our original list that will interact with each other and form networks
  puts net.network  # Showing the full networks which contain the original genes as well as those outside the list 
  puts '' # Printing an space between each network found, to better visualize it in the terminal
end

