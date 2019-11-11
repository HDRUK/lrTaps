echo -e "chr11:32,182,181-32,198,796"|sed 's/:/\t/g;s/,//g;s/-/\t/g'|\
intersectBed -a - -b <(cut -f3,5,6,10,13,14 /users/ludwig/cfo155/cfo155/userEnrich/resource/refGene.txt ) -wa -wb |\
cut -f4,5,6,8 |bedtools getfasta -bed - -fi /users/ludwig/cfo155/cfo155/userEnrich/resource/mm9_genome.fa -name+ |\
paste - - |awk 'NR==1||NR==5' |sed 's/\t/\n/g' >hba_a1.fasta