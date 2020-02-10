
#!/bin/bash

#$ -N callMeth
#$ -P ludwig.prjc
#$ -q short.qc
#$ -cwd
#$ -o run_callMeth.log
#$ -e run_callMeth.err
#$ -pe shmem 5

# Some useful data about the job to help with debugging
echo "------------------------------------------------"
echo "SGE Job ID: $JOB_ID"
echo "SGE Task ID: $SGE_TASK_ID"
echo "Run on host: "`hostname`
echo "Operating system: "`uname -s`
echo "Username: "`whoami`
echo "Started at: "`date`
echo "Argument: $@"
echo "------------------------------------------------"

# set PATH
PATH=$PATH:/users/ludwig/cfo155/miniconda2/bin
export PATH

# set dir
WORKDIR=/users/ludwig/cfo155/cfo155/longReads
cd $WORKDIR


# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.ccgg.meth.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.nometh.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.taps.KU.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.taps.LA.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep1.4kb.nometh.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep1.4kb.taps.KU.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep1.4kb.taps.LA.bam -l 3500 -a resource/4kb.cg.bed

Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.ccgg.meth.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed
Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.nometh.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed
Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.taps.KU.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed
Rscript code/mCG_lrtaps.r -b processed/nanopore_rep1.4kb.taps.LA.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed
Rscript code/mCG_lrtaps.r -b processed/pacbio_rep1.4kb.nometh.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed
Rscript code/mCG_lrtaps.r -b processed/pacbio_rep1.4kb.taps.KU.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed
Rscript code/mCG_lrtaps.r -b processed/pacbio_rep1.4kb.taps.LA.del_rm.bam -l 3500 -a resource/4kb.del_rm.cg.bed

# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.lambda.ccgg.no_taps.bam -l 8000 -a resource/lambda.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.lambda.ccgg.taps.bam -l 8000 -a resource/lambda.cg.bed

# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.lambda.ccgg.no_taps.bam -l 8000 -a resource/lambda.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.lambda.ccgg.taps.bam -l 8000 -a resource/lambda.cg.bed

# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.hbv_percent_1.no_taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.hbv_percent_1.taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.hbv_percent_20.no_taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.hbv_percent_20.taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# 
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.hbv_hep3b.no_taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.hbv_hep3b.taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.hbv_huh1.no_taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.hbv_huh1.taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed

# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.hbv_percent_20.taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.hbv_percent_20.no_taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.hbv_hep3b.taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.hbv_hep3b.no_taps.bam -l 1700 -a resource/7513-wtA-Consensus20.cg.bed ## reads is short than 2000
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.hbv_huh1.taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.hbv_huh1.no_taps.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
### selct read start from specific region ###
# samtools view -h processed/nanopore_rep3.hbv_huh1.no_taps.bam|awk '$0~/^@/||($4>690&&$4<720&&($2==0||$2==16))'|samtools view -bS - >processed/nanopore_rep3.hbv_huh1.no_taps.sel.bam
# samtools view -h processed/nanopore_rep3.hbv_huh1.taps.bam|awk '$0~/^@/||($4>690&&$4<720&&($2==0||$2==16))'|samtools view -bS - >processed/nanopore_rep3.hbv_huh1.taps.sel.bam
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.hbv_huh1.no_taps.sel.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.hbv_huh1.taps.sel.bam -l 2000 -a resource/7513-wtA-Consensus20.cg.bed
# samtools view -bS processed/nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.bam chr11:32180718-32188962 >processed/nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.chr11.bam
# samtools view -bS processed/nanopore_rep2.mESC_chr11_32180718_32188962.taps.bam chr11:32180718-32188962 >processed/nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11.bam
# samtools view -bS processed/nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.bam chr13:101122480-101130466 >processed/nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.chr13.bam
# samtools view -bS processed/nanopore_rep2.mESC_chr13_101122480_101130466.taps.bam chr13:101122480-101130466  >processed/nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13.bam
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.chr11.bam -l 3000 -a resource/mm9_genome.cg.chr11.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11.bam -l 3000 -a resource/mm9_genome.cg.chr11.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.chr13.bam -l 3000 -a resource/mm9_genome.cg.chr13.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13.bam -l 3000 -a resource/mm9_genome.cg.chr13.bed
# 
# samtools view -bS processed/nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.bam chr11:32182210-32187470 >processed/nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.chr11.bam
# samtools view -bS processed/nanopore_rep3.mESC_chr11_32180718_32188962.taps.bam chr11:32182210-32187470 >processed/nanopore_rep3.mESC_chr11_32180718_32188962.taps.chr11.bam
# 
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.chr11.bam -l 5000 -a resource/mm9_genome.cg.chr11.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.mESC_chr11_32180718_32188962.taps.chr11.bam -l 5000 -a resource/mm9_genome.cg.chr11.bed
# 
# 
# samtools view -bS processed/nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.bam chr11:32182210-32187470 >processed/nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.chr11.bam
# samtools view -bS processed/nanopore_rep3.mESC_chr11_32180718_32188962.taps.bam chr11:32182210-32187470 >processed/nanopore_rep3.mESC_chr11_32180718_32188962.taps.chr11.bam
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.chr11.bam -l 5000 -a resource/mm9_genome.cg.chr11.bed
# Rscript code/mCG_lrtaps.r -b processed/nanopore_rep3.mESC_chr11_32180718_32188962.taps.chr11.bam -l 5000 -a resource/mm9_genome.cg.chr11.bed
# 
# samtools view -bS processed/pacbio_rep2.mESC_chr11_32180718_32188962.5261.taps.bam chr11:32182210-32187470 >processed/pacbio_rep2.mESC_chr11_32180718_32188962.5261.taps.chr11.bam
# samtools view -bS processed/pacbio_rep2.mESC_chr11_32180718_32188962.5261.no_taps.bam chr11:32182210-32187470 >processed/pacbio_rep2.mESC_chr11_32180718_32188962.5261.no_taps.chr11.bam
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.mESC_chr11_32180718_32188962.5261.taps.chr11.bam  -l 3000 -a resource/mm9_genome.cg.chr11.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.mESC_chr11_32180718_32188962.5261.no_taps.chr11.bam -l 3000 -a resource/mm9_genome.cg.chr11.bed
# 
# samtools view -bS processed/pacbio_rep2.mESC_chr11_32180718_32188962.4053.taps.bam chr11:32183629-32187681 >processed/pacbio_rep2.mESC_chr11_32180718_32188962.4053.taps.chr11.bam 
# samtools view -bS processed/pacbio_rep2.mESC_chr11_32180718_32188962.4053.no_taps.bam chr11:32183629-32187681 >processed/pacbio_rep2.mESC_chr11_32180718_32188962.4053.no_taps.chr11.bam
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.mESC_chr11_32180718_32188962.4053.taps.chr11.bam  -l 3000 -a resource/mm9_genome.cg.chr11.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.mESC_chr11_32180718_32188962.4053.no_taps.chr11.bam -l 3000 -a resource/mm9_genome.cg.chr11.bed
# 
# samtools view -bS processed/pacbio_rep2.mESC_chr13_101122480_101130466.taps.bam chr13:101122480-101130466 >processed/pacbio_rep2.mESC_chr13_101122480_101130466.taps.chr13.bam
# samtools view -bS processed/pacbio_rep2.mESC_chr13_101122480_101130466.no_taps.bam chr13:101122480-101130466 >processed/pacbio_rep2.mESC_chr13_101122480_101130466.no_taps.chr13.bam
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.mESC_chr13_101122480_101130466.taps.chr13.bam -l 3000 -a resource/mm9_genome.cg.chr13.bed
# Rscript code/mCG_lrtaps.r -b processed/pacbio_rep2.mESC_chr13_101122480_101130466.no_taps.chr13.bam -l 3000 -a resource/mm9_genome.cg.chr13.bed

# depth statistics
echo -e "chr11\t32183629\t32187681" |intersectBed -a - -b <(tail -n +2 taps_pub.rmdup_mCtoT_CpG.mods) -wa -wb|awk '{sum+=$8+$9}END{print sum/NR}'
echo -e "chr11\t32183629\t32187681" |intersectBed -a - -b <(tail -n +2 taps_pub.rmdup_mCtoT_CpG.mods) -wa -wb|awk '{sum+=$15}END{print sum/NR}'
awk '{sum+=$7}END{print sum/NR}' nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11.CG.meth.xls
awk '{sum+=$7}END{print sum/NR}' pacbio_rep2.mESC_chr11_32180718_32188962.4053.taps.chr11.CG.meth.xls