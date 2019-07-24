
#!/bin/bash

#$ -N callMeth
#$ -P ludwig.prjc
#$ -q short.qc
#$ -cwd
#$ -o run_callMeth.log
#$ -e run_callMeth.err
#$ -pe shmem 8

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

# Rscript code/script_LRtaps.r -b processed/nanopore_rep1.4kb.ccgg.meth.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep1.4kb.nometh.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep1.4kb.taps.KU.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep1.4kb.taps.LA.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/script_LRtaps.r -b processed/pacbio_rep1.4kb.nometh.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/script_LRtaps.r -b processed/pacbio_rep1.4kb.taps.KU.bam -l 3500 -a resource/4kb.cg.bed
# Rscript code/script_LRtaps.r -b processed/pacbio_rep1.4kb.taps.LA.bam -l 3500 -a resource/4kb.cg.bed

# Rscript code/script_LRtaps.r -b processed/nanopore_rep2.lambda.ccgg.no_taps.bam -l 8000 -a resource/lambda.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep2.lambda.ccgg.taps.bam -l 8000 -a resource/lambda.cg.bed
 
# Rscript code/script_LRtaps.r -b processed/nanopore_rep2.hbv_percent_1.no_taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep2.hbv_percent_1.taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep2.hbv_percent_20.no_taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed
# Rscript code/script_LRtaps.r -b processed/nanopore_rep2.hbv_percent_20.taps.bam -l 3000 -a resource/7513-wtA-Consensus20.cg.bed

# samtools view -bS processed/nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.bam chr11:32180718-32188962 >processed/nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.chr11.bam
# samtools view -bS processed/nanopore_rep2.mESC_chr11_32180718_32188962.taps.bam chr11:32180718-32188962 >processed/nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11.bam
# samtools view -bS processed/nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.bam chr13:101122480-101130466 >processed/nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.chr13.bam
# samtools view -bS processed/nanopore_rep2.mESC_chr13_101122480_101130466.taps.bam chr13:101122480-101130466  >processed/nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13.bam
Rscript code/script_LRtaps.r -b processed/nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.chr11.bam -l 3000 -a resource/mm9_genome.cg.chr11.bed
Rscript code/script_LRtaps.r -b processed/nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11.bam -l 3000 -a resource/mm9_genome.cg.chr11.bed
Rscript code/script_LRtaps.r -b processed/nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.chr13.bam -l 3000 -a resource/mm9_genome.cg.chr13.bed
Rscript code/script_LRtaps.r -b processed/nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13.bam -l 3000 -a resource/mm9_genome.cg.chr13.bed