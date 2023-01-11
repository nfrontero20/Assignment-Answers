# Assignment 4 Writeup
## Nicole Frontero

Discuss sensible BLAST parameters
Bonus question

**Orthologues** are genes that are found in different species that evolved from a common ancestral gene by speciation.  Often, orthologous genes retain the same function over the course of evolution [(Wikipedia)](https://en.wikipedia.org/wiki/Orthology).

To discover orthologues, the first step is often a **"reciprocal best BLAST"**.  First, you take protein X in Species A and BLAST it against all proteins in Species B.  Then, you BLAST the top (significant) hit in Species B against all proteins in Species A.  If the top/significant hit is Protein X, then these two proteins are considered **orthologue candidates**.  

In this investigation, we use BioRuby to find orthologue pairs between **Arabidopsis** and **S. pombe**.  We needed to spcify two particular parameters: **e-value** and **coverage**.

[()]()

The **e-value**, which stands for "expect value", measures the number of hits one can expect to see by chance when searching a database of a particular size [(NCBI)](https://blast.ncbi.nlm.nih.gov/Blast.cgi?CMD=Web&PAGE_TYPE=BlastDocs&DOC_TYPE=FAQ).  In this way, the e-value serves as a measure of significance and may remind you of the commonly heard of p-value.  

An basic internet search (not of academic papers) reveals the following about e-values: 


To decide on "sensible" BLAST parameters, do a bit of online reading - when you have decided what parameters to use, please cite the paper or website that provided the information.


## References

- 
