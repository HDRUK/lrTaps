ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/compareTaps/4kb.fa
ln -s /users/ludwig/cfo155/cfo155/17042019/resource/mm9/mm9_genome.fa
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/7513-wtA-Consensus20.fa 
ln -s /users/ludwig/cfo155/cfo155/17042019/resource/bsgenome/lambda.fasta lambda.fa

ln -s /users/ludwig/cfo155/cfo155/userEnrich/resource/mm9_genome.cg.bed
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/compareTaps/4kb.ccgg.bed
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/lambda.CCGG.bed

getCGPos(){
  sequences=$1
  mkdir temp
  fasta_formatter -i $sequences -t|sed 's/>//g'|\
  awk 'BEGIN{OFS="\t"}{print $2>"temp/"$1".fa"}' # one sequence for each chr
  if test -f ${sequences/.fa/}.cg.bed; then rm ${sequences/.fa/}.cg.bed -rf ; fi
  for sequence in `ls temp/*.fa` # get CG position
  do
    chr=`echo $sequence |cut -d '/' -f2|sed 's/.fa//g'`
    grep -aob -i CG $sequence |sed 's/:/\t/g'|\
    awk -v chr=${chr} 'BEGIN{OFS="\t"}{print chr,$1,$1+1,$2}' >>${sequences/.fa*/}.cg.bed
  done
  rm temp -rf 
}
getCGPos resource/4kb.fa
getCGPos resource/lambda.fa
getCGPos resource/7513-wtA-Consensus20.fa 
grep -w chr11 mm9_genome.cg.bed >mm9_genome.cg.chr11.bed
grep -w chr13 mm9_genome.cg.bed >mm9_genome.cg.chr13.bed