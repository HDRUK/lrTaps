# on 4kb
BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA'
#reference=resource/4kb.fa include 3 deletions
reference=resource/4kb.del_rm.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.del_rm.bam
done

# on Lambda
BARCODES='nanopore_rep2.lambda.ccgg.no_taps nanopore_rep2.lambda.ccgg.taps'
BARCODES='pacbio_rep2.lambda.ccgg.taps pacbio_rep2.lambda.ccgg.no_taps'
reference=resource/lambda.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq |samtools sort -T tmp -o processed/${bc}.bam
done
# on hbv
BARCODES='nanopore_rep2.hbv_percent_1.no_taps nanopore_rep2.hbv_percent_1.taps nanopore_rep2.hbv_percent_20.no_taps nanopore_rep2.hbv_percent_20.taps'
BARCODES='nanopore_rep3.hbv_hep3b.no_taps nanopore_rep3.hbv_hep3b.taps nanopore_rep3.hbv_huh1.no_taps nanopore_rep3.hbv_huh1.taps'
BARCODES='pacbio_rep2.hbv_percent_20.taps pacbio_rep2.hbv_percent_20.no_taps pacbio_rep2.hbv_hep3b.taps pacbio_rep2.hbv_hep3b.no_taps pacbio_rep2.hbv_huh1.taps pacbio_rep2.hbv_huh1.no_taps'
reference=resource/7513-wtA-Consensus20.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.bam
done
# try another genome for hpv since reads in hep3b.no_taps got lot of soft clip when mapping to 7513-wtA-Consensus20.fa
# and the clipped sequence were mapped to https://www.ncbi.nlm.nih.gov/nuccore/JX310722.1?report=fasta
for i in `ls nanopore_rep3.hbv*bam`
do
echo $i \
`samtools view $i |awk '$2==0||$2==16'|cut -f6|sed 's/\([0-9]*[A-Z]*\).*/\1/g' |grep S|\
sed 's/S//g'|awk '{sum+=$1}END{print sum/NR,NR}'`
done
BARCODES='nanopore_rep3.hbv_hep3b.no_taps nanopore_rep3.hbv_hep3b.taps nanopore_rep3.hbv_huh1.no_taps nanopore_rep3.hbv_huh1.taps'
reference=resource/hbv_genome.edit.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.hbv_genome.edit.bam
    samtools view -h processed/${bc}.hbv_genome.edit.bam |awk '$0~/^@/||$2==0||$2==16'|samtools view -bS - >processed/${bc}.hbv_genome.edit.proper.bam
    samtools index processed/${bc}.hbv_genome.edit.proper.bam
done
BARCODES='nanopore_rep3.hbv_hep3b.no_taps nanopore_rep3.hbv_hep3b.taps nanopore_rep3.hbv_huh1.no_taps nanopore_rep3.hbv_huh1.taps'
reference=resource/hbv_genome.edit2.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.hbv_genome.edit2.bam
    samtools view -h processed/${bc}.hbv_genome.edit2.bam |awk '$0~/^@/||$2==0||$2==16'|samtools view -bS - >processed/${bc}.hbv_genome.edit2.proper.bam
    samtools index processed/${bc}.hbv_genome.edit2.proper.bam
done
# on mESC
BARCODES='nanopore_rep2.mESC_chr11_32180718_32188962.no_taps nanopore_rep2.mESC_chr11_32180718_32188962.taps nanopore_rep2.mESC_chr13_101122480_101130466.no_taps nanopore_rep2.mESC_chr13_101122480_101130466.taps'
BARCODES='nanopore_rep3.mESC_chr11_32180718_32188962.no_taps nanopore_rep3.mESC_chr11_32180718_32188962.taps'
BARCODES='pacbio_rep2.mESC_chr11_32180718_32188962.5261.taps pacbio_rep2.mESC_chr11_32180718_32188962.5261.no_taps pacbio_rep2.mESC_chr13_101122480_101130466.taps pacbio_rep2.mESC_chr13_101122480_101130466.no_taps pacbio_rep2.mESC_chr11_32180718_32188962.4053.taps pacbio_rep2.mESC_chr11_32180718_32188962.4053.no_taps '
reference=resource/mm9_genome.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.bam
done

