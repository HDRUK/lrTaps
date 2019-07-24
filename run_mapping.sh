# on 4kb
BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA'
reference=resource/4kb.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.bam
done

# on Lambda
BARCODES='nanopore_rep2.lambda.ccgg.no_taps nanopore_rep2.lambda.ccgg.taps'
reference=resource/lambda.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.bam
done

# on hbv cccDNA
BARCODES='nanopore_rep2.hbv_percent_1.no_taps nanopore_rep2.hbv_percent_1.taps nanopore_rep2.hbv_percent_20.no_taps nanopore_rep2.hbv_percent_20.taps'
reference=resource/7513-wtA-Consensus20.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.bam
done

# on mESC
BARCODES='nanopore_rep2.mESC_chr11_32180718_32188962.no_taps nanopore_rep2.mESC_chr11_32180718_32188962.taps nanopore_rep2.mESC_chr13_101122480_101130466.no_taps nanopore_rep2.mESC_chr13_101122480_101130466.taps'
reference=resource/mm9_genome.fa
for bc in $BARCODES
do
    minimap2 -a -x map-ont $reference rawdata/$bc.fastq | samtools sort -T tmp -o processed/${bc}.bam
done

