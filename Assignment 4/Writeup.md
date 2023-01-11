# Assignment 4 Writeup
## Nicole Frontero

Discuss sensible BLAST parameters
Bonus question

**Orthologues** are genes that are found in different species that evolved from a common ancestral gene by speciation.  Often, orthologous genes retain the same function over the course of evolution [(Wikipedia)](https://en.wikipedia.org/wiki/Orthology).

To discover orthologues, the first step is often a **"reciprocal best BLAST"**.  First, you take protein X in Species A and BLAST it against all proteins in Species B.  Then, you BLAST the top (significant) hit in Species B against all proteins in Species A.  If the top/significant hit is Protein X, then these two proteins are considered **orthologue candidates**.  

In this investigation, we use BioRuby to find orthologue pairs between **Arabidopsis** and **S. pombe**.  We needed to spcify two particular parameters: **e-value** and **coverage**.

[()]()

The **e-value**, which stands for "expect value", measures the number of hits one can expect to see by chance when searching a database of a particular size [(NCBI)](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=FAQ).  In this way, the e-value serves as a measure of significance and may remind you of the commonly heard of p-value.  

A basic internet search (not of academic papers) reveals the following about e-values: 
- E-value < 10e-100 Identical sequences. You will get long alignments across the entire query and hit sequence.
- 10e-100 < E-value < 10e-50 Almost identical sequences. A long stretch of the query protein is matched to the database.
- 10e-50 < E-value < 10e-10 Closely related sequences, could be a domain match or similar.
- 10e-10 < E-value < 1 Could be a true homologue but it is a gray area.
- E-value > 1 Proteins are most likely not related
- E-value > 10 Hits are most likely junk unless the query sequence is very short.

To decide on "sensible" BLAST parameters, do a bit of online reading - when you have decided what parameters to use, please cite the paper or website that provided the information.


## References

- 
