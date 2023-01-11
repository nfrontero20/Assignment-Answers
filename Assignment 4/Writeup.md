# Assignment 4 Writeup
## Background

**Orthologues** are genes that are found in different species that evolved from a common ancestral gene by speciation.  Often, orthologous genes retain the same function over the course of evolution [(Wikipedia)](https://en.wikipedia.org/wiki/Orthology).

To discover orthologues, the first step is often a **"reciprocal best BLAST"**.  First, you take protein X in Species A and BLAST it against all proteins in Species B.  Then, you BLAST the top (significant) hit in Species B against all proteins in Species A.  If the top/significant hit is Protein X, then these two proteins are considered **orthologue candidates**.  

In this investigation, we use BioRuby to find orthologue pairs between **Arabidopsis** and **S. pombe**.  [Arabidopsis](https://www.arabidopsis.org/portals/education/aboutarabidopsis.jsp) is a small flowering plant that is a member of the Brassicaceae family and it is widely used as a model organism in plant biology.  [S. pombe](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4596657/), which stands for Schizosaccharomyces pombe, is known as fission yeast.  It is an important model organism for studying eukaryotic molecular and cellcular biology.

## Parameters

The **e-value**, which stands for "expect value", measures the number of hits one can expect to see by chance when searching a database of a particular size [(NCBI)](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=FAQ).  In this way, the e-value serves as a measure of significance and may remind you of the commonly heard of p-value.  Note that the e-value depends on the length of the database [(Ricardo Avila Bioinformatics Website)](https://ravilabio.info/notes/bioinformatics/e-value-bitscore.html).

There is no consensus on the e-value to choose, especially given that it depends on your goals and on the size of the database.  Nevertheless, here are some opinions and philosophies found on the internet.

From [Qiagen Digital Insights:](https://resources.qiagenbioinformatics.com/manuals/clcgenomicsworkbench/650/_E_value.html)
- e-value < 10e-100: Identical sequences. You will get long alignments across the entire query and hit sequence.
- 10e-100 < e-value < 10e-50: Almost identical sequences. A long stretch of the query protein is matched to the database.
- 10e-50 < e-value < 10e-10: Closely related sequences, could be a domain match or similar.
- 10e-10 < e-value < 1: Could be a true homologue but it is a gray area.
- e-value > 1: Proteins are most likely not related
- e-value > 10: Hits are most likely junk unless the query sequence is very short.

Then, a [bioinformatics resource from the University of Bologna](http://www.biocomp.unibo.it/casadio/LMBIOTEC/evalue) takes a less rigorous approach, simply stating that the typical threshold for a good e−value from a BLAST search is e−5=(10−5) or lower.

Meanwhile, [Metagenomics.Wiki](https://www.metagenomics.wiki/tools/blast/evalue) indicates the following about e-values: 
- e-value = 1e-50: small e-value, low number of hits, but of high quality.  Blast hits with an e-value smaller than 1e-50 includes database matches of very high quality.
- e-value = 1e-2: Blast hits with e-value smaller than 0.01 can still be considered as good hit for homology matches.
- e-value = 10: large e-value, many hits, partly of low quality.  E-value smaller than 10 will include hits that cannot be considered as significant, but may give an idea of potential relations.

I decided to use an **e-value of 1e-6** (meaning, e-value less than 1e-6).  I figured that I could stand to be a little more aggressive than what the University of Bologna webpage suggested, but not as intense as what Qiagen Digital Insights was proposing counted as a "good" e-value.  Also, I reasoned that choosing 1e-6 fell in line with what Metagenomics.Wiki was looking for, still while not being too aggressive.

The other parameter I incorporated into the code was the **query coverage**.  Coverage is the percentage of the query sequence length that is included in the alignment [(Newell et al., 2013)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3867762/).  Oftentimes what can happen when running a BLAST search is that the sequences returned will only align with part of a queried sequence.  As a result, the greater the query coverage, the lower the e-value and the better the match [(Newell et al., 2013)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3867762/). 

I chose to follow the example set by Moreno-Hagelsieb et al. in their very helpful article titled ["Choosing BLAST options for better detection of orthologs as reciprocal best hits"](https://academic.oup.com/bioinformatics/article/24/3/319/252715) and **used a coverage of 50%** (meaning, coverage greater than 50%).

## Bonus Question 

The bonus question asks us to "write a few sentences describing how you would continue to analyze the putative orthologues you just discovered, to prove that they really are orthologues".

I did some research on orthology analysis and consulted an article titled ["New Tools in Orthology Analysis: A Brief Review of Promising Perspectives"](https://www.frontiersin.org/articles/10.3389/fgene.2017.00165/full#h3).  The authors highlighted the difficulty in detecting orthologous groups and stated that a "set of tools" rather than one specific analysis is required in order to best detect orthologues. To this end, they reviewed many tools and discussed their usefulness.  

Therefore, as an answer to the bonus question, I would say that I would perform additional analyses using some of the methods I am about to mention.  

1. PorthoMCL: PorthoMCL is an orthology predictor.  After "all-against-all" and "individual-against-all" searches are performed in BLAST, the algorithm finds the RBH between the two genomes and calculates the normalized sccore.  Then, PorthoMCL finds the within genomes RBH and normalizes the score with the average score of all paralog pairs that have orthologs in other genomes.  Finally, the output is a sequence similarlity graph that the MCL program then cuts to predict orthologous and paralogous groups [(Tabari and Su, 2017)](https://bdataanalytics.biomedcentral.com/articles/10.1186/s41044-016-0019-8). 
2. OrthAgogue: OrthAgogue is an algorithm that takes as input the best high-scoring pairs in BLAST output to then continue searching for orthologous groups.  The authors of "New Tools in Orthology Analysis" highlight that orthAgogue is particularly convenient when working on large amounts of data with computers of limited capabilities.  The paper with the original findings can be found [here](https://academic.oup.com/bioinformatics/article/30/5/734/245731). 
3. Hieranoid: This is a graph-based method that uses hierarchical approaches.  The benefits of this method include scalability and accuracy [("New Tools in Orthology Analysis: A Brief Review of Promising Perspectives")](https://www.frontiersin.org/articles/10.3389/fgene.2017.00165/full#h3).  The creators of the software write the following:

*"Hieranoid performs pairwise orthology analysis using InParanoid at each node in a guide tree as it progresses from its leaves to the root. This concept reduces the total runtime complexity from a quadratic to a linear function of the number of species. The tree hierarchy provides a natural structure in multi-species ortholog groups, and the aggregation of multiple sequences allows for multiple alignment similarity searching techniques, which can yield more accurate ortholog groups"* [(Schreiber, F., and Sonnhammer, E. L., 2013)](https://www.sciencedirect.com/science/article/pii/S0022283613001204).
