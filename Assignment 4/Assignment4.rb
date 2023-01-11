# NOTE 1: To run the program, execute the following in the command line:
  # ruby Assignment4.rb Spombe.fa Arabidopsis.fa
# NOTE 2: Please refer to Writeup.md for a description of the BLAST parameters utilized and the values I chose for them.
# NOTE 3: The following BLAST programs are utilized in this script
  # blastx: query:translatednucleotide (Arabidopsis); db:protein (S.pombe)
  # tblastn: query:protein (S.pombe); db:translatednucleotide (Arabidopsis)

# We need this to use the BioRuby classes 
require 'bio'

# METHOD 1: Guess the BLAST program based on the type of sequencies in query and database: nucleotide/protein
def blast_program(flat_fasta_query,flat_fasta_db)
  # Pass the first sequences of query and db to Bio::Sequence objects
  # next_entry takes the next entry of the file
  query_first_seq = flat_fasta_query.next_entry.to_biosequence
  db_first_seq = flat_fasta_db.next_entry.to_biosequence
  # Indicate which BLAST program to use in each case
  if query_first_seq.guess.equal? Bio::Sequence::NA and db_first_seq.guess.equal? Bio::Sequence::AA
    blast_program = 'blastx'
  elsif query_first_seq.guess.equal? Bio::Sequence::AA and db_first_seq.guess.equal? Bio::Sequence::NA
    blast_program = 'tblastn'
  else
    puts "Do not know which program to use"
  end 
  return blast_program
end

# METHOD 2: Create a Bio::FlatFile object to guess blast program and to iterate over each query
def create_flat_file(fasta_file)
  flat_file = Bio::FlatFile.auto(fasta_file)
  return flat_file
end

# METHOD 3: Create a database 
def create_database(program_blast,fasta_file)
  # Remove the '.fa' extension
  name_db = fasta_file.split('.')[0]
  if program_blast == 'blastx'
    `makeblastdb -in #{fasta_file} -dbtype 'prot' -out #{name_db}`
  elsif program_blast == 'tblastn'
    `makeblastdb -in #{fasta_file} -dbtype 'nucl' -out #{name_db}`
  end
end

# METHOD 4: Do a BLAST and retrieve the best hit with parameters 
def blast_best_hit(prog,db,query)
  # Define parameters
  evalue_threshold = 1e-06 # evalue chosen according to literature consulted (see Writeup.md)
  coverage_threshold = 0.5 # coverage chosen according to literature consulted (see Writeup.md)
  # Create a BLAST factory
  factory = Bio::Blast.local(prog,"#{File.dirname(db)}/#{File.basename(db,".fa")}") 
  # Run the actual BLAST by querying the factory
  report = factory.query(query)
  if report.hits[0] != nil 
    if prog == "tblastn"
      coverage = report.hits[0].overlap.to_f/query.length.to_f
    elsif prog == "blastx"
      entry_length = query.length/3
      coverage = report.hits[0].overlap.to_f/entry_length.to_f
    end
    
    evalue = report.hits[0].evalue.to_f
    
    # Specify that coverage must be greater than or equal to the coverage_threshold and that the evalue must be less than or equal to the evalue threshold
    if coverage >= coverage_threshold && evalue <= evalue_threshold
      return report.hits[0].definition.split("|")[0].strip
    end
  end
end

# METHOD 5: Find the reciprocal best hits 
def reciprocal_best_hits(file_1,file_2)
  flat_file_1 = create_flat_file(file_1)
  flat_file_2 = create_flat_file(file_2)
  
  # Define the BLASTS
  # BLAST 1: Query = S.pombe (flat_file_1); Database = Arabidopsis (flat_file_2) 
  blast_1 = blast_program(flat_file_1,flat_file_2)
  # BLAST 2: Query = Arabidopsis (flat_file_2); Database = S.pombe (flat_file_1)
  blast_2 = blast_program(flat_file_2,flat_file_1)
   
  # BLAST 1: Query = S.pombe; Database = Arabidopsis
  # Create new empty hash to store best hits from BLAST 1
  best_hits = Hash.new
  # Create new empty hash to store ortholog candidates 
  orthologues_candidates = Hash.new
  # Create Arabidopsis database
  create_database(blast_1,file_2)
  # Rewind resets file pointer to the start of the flatfile
  flat_file_1.rewind 
  # Iterate over each entry in file_1 
  flat_file_1.each do |query|
    # Print to the command line
    puts "BLAST 1 (S.pombe queries against Arabidopsis): query #{query.entry_id}..."
    # Retrieve the best hit
    best_hit = blast_best_hit(blast_1,file_2,query)
    if best_hit != nil
      # If there is a best hit, print it to the command line
      puts "The best hit is #{best_hit}"
      best_hits[query.entry_id] = best_hit
    # If there is not a best hit, print that to the command line
    elsif best_hit == nil
      puts "There are not best hits for this query"
    end
  end 
  
  # BLAST 2: Query = Arabidopsis; Database = S.pombe
  # Create S.pombe database
  create_database(blast_2,file_1)
  # Rewind resets file pointer to the start of the flatfile
  flat_file_2.rewind 
  # Do the BLAST only if the Arabidopsis query is in the list of best hits
  flat_file_2.each do |query|
    # Note that entry_id now is now the same as hits[0].definition from before
    if best_hits.values.include? query.entry_id 
      # Print to command line
      puts  "BLAST 2 (Arabidopsis (best hits) queries against S.pombe): query #{query.entry_id}..."
      best_hit = blast_best_hit(blast_2,file_1,query)
      if best_hit != nil && best_hits[best_hit] == query.entry_id
        # Print to command line
        puts "The best hit is #{best_hit} --> #{best_hit} and #{query.entry_id} are orthologues candidates"
        # Store pairs of reciprocal hits in the dictionary
        orthologues_candidates[best_hit] = query.entry_id
      end
    end
  end
  return orthologues_candidates 
end

# EXECUTING THE PROGRAM
rbh = reciprocal_best_hits(ARGV[0],ARGV[1])
puts "RBH search has been completed"
# Writing the report (creating report.txt)
File.open('report.txt', 'w+') do |line|
   line.puts "Pairs of orthologues candidates:"
   rbh.each do |key,value|
      line.puts "\t #{key} and #{value}"
   end
end
puts "Report with pairs of orthologues candidates has been generated"
