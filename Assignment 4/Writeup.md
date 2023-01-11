# Assignment 4 Writeup
## Nicole Frontero

Discuss sensible BLAST parameters
Bonus question

**Orthologues** are genes that are found in different species that evolved from a common ancestral gene by speciation.  Often, orthologous genes retain the same function over the course of evolution [(Wikipedia)](https://en.wikipedia.org/wiki/Orthology).

To discover orthologues, the first step is often a **"reciprocal best BLAST"**.  First, you take protein X in Species A and BLAST it against all proteins in Species B.  Then, you BLAST the top (significant) hit in Species B against all proteins in Species A.  If the top/significant hit is Protein X, then these two proteins are considered **orthologue candidates**.  

In this investigation, we use BioRuby to find orthologue pairs between **Arabidopsis** and **S. pombe**.  We needed to spcify two particular parameters: **e-value** and **coverage**.

[()]()

The **e-value**, which stands for "expect value", measures the number of hits one can expect to see by chance when searching a database of a particular size [(NCBI)](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=FAQ).  In this way, the e-value serves as a measure of significance and may remind you of the commonly heard of p-value.  Note that the e-value depends on the length of the database [(Ricardo Avila Bioinformatics Website)](https://ravilabio.info/notes/bioinformatics/e-value-bitscore.html).

There is no consensus on the e-value to choose, especially given that it depends on your goals and on the size of the database.  Nevertheless, here are some opinions and philosophies found on the internet.

From [Qiagen Digital Insights:](https://resources.qiagenbioinformatics.com/manuals/clcgenomicsworkbench/650/_E_value.html)
- e-value < 10e-100 Identical sequences. You will get long alignments across the entire query and hit sequence.
- 10e-100 < e-value < 10e-50: Almost identical sequences. A long stretch of the query protein is matched to the database.
- 10e-50 < e-value < 10e-10: Closely related sequences, could be a domain match or similar.
- 10e-10 < e-value < 1: Could be a true homologue but it is a gray area.
- e-value > 1: Proteins are most likely not related
- e-value > 10: Hits are most likely junk unless the query sequence is very short.

Then, a [bioinformatics resource from the University of Bologna](http://www.biocomp.unibo.it/casadio/LMBIOTEC/evalue) takes a less detailed approach, simply stating that the typical threshold for a good e−value from a BLAST search is e−5=(10−5) or lower.

Meanwhile, [(Metagenomics.Wiki)](https://www.metagenomics.wiki/tools/blast/evalue) indicates the following about e-values: 
- e-value = 1e-50: small e-value, low number of hits, but of high quality.  Blast hits with an E-value smaller than 1e-50  includes database matches of very high quality.
-e-value = 1e-2: Blast hits with e-value smaller than 0.01 can still be considered as good hit for homology matches.
-evalue = 10: large e-value, many hits, partly of low quality.  E-value smaller than 10 will include hits that cannot be considered as significant, but may give an idea of potential relations.

I decided to use an **e-value of 1e-6**.  I figured that I could stand to be a little more aggressive than what the University of Bologna webpage suggested, but not as intense as what Qiagen Digital Insights was proposing counted as a "good" e-value and reasoned that choosing 1e-6 fell in line with what Metagenomics.Wiki was looking for.

The other parameter I incorporated into the code was the **coverage**.  Coverage is the percentage of the query sequence length that is included in the alignment [Newell et al., 2013](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3867762/).  Oftentimes what can happen when running a BLAST search is that the sequences returned will only align with part of a queried sequence.  As a result, the greater the query coverage, the lower the e-value and the better the match [Newell et al., 2013](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3867762/). 

We chose to follow the example set by Moreno-Hagelsieb et al. in their very helpful article titled ["Choosing BLAST options for better detection of orthologs as reciprocal best hits"](https://academic.oup.com/bioinformatics/article/24/3/319/252715) and **used a coverage of 50%**.
