# Assignment 4 Writeup
## Nicole Frontero

Discuss sensible BLAST parameters
Bonus question

Orthologues are genes that are found in different species that evolved from a common ancestral gene by speciation.  Often, orthologous genes retain the same function over the course of evolution [(Wikipedia)](https://en.wikipedia.org/wiki/Orthology).

To discover orthologues, the first step is often a "reciprocal best BLAST".  First, you take protein X in Species A and BLAST it against all proteins in Species B.  Then, you BLAST the top (significant) hit in Species B against all proteins in Species A.  If the top/significant hit is Protein X, then these two proteins are considered *orthologue candidates*.  

In this investigation, we use BioRuby to find orthologue pairs between **Arabidopsis** and **S. pombe**.  We needed to decide on BLAST parameters that make sense, and here is what we decided upon (with an explanation to follow): 
- **e-value**
- **cutoff**


To decide on "sensible" BLAST parameters, do a bit of online reading - when you have decided what parameters to use, please cite the paper or website that provided the information.


## References

- 
