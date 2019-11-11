##### data for rep3 #####
for bc in `ls -d barcode*`
do
    cat $bc/*fastq >$bc.fastq
done
# 1. mESC chr11 TAPS = NB13
# 2. mESC chr11 Ctrl = NB14
# 3. Hep3B TAPS = NB15
# 4. Hep3B Ctrl = NB16
# 5. Huh-1 TAPS = NB17
# 6. Huh-1 Ctrl = NB18
ln -s rep3/fastq-trimmed/fastq-trimmed-barcode13-2.3.5.fastq nanopore_rep3.mESC_chr11_32180718_32188962.taps.fastq
ln -s rep3/fastq-trimmed/fastq-trimmed-barcode14-2.3.5.fastq nanopore_rep3.mESC_chr11_32180718_32188962.no_taps.fastq
ln -s rep3/fastq-trimmed/fastq-trimmed-barcode15-2.3.5.fastq nanopore_rep3.hbv_hep3b.taps.fastq
ln -s rep3/fastq-trimmed/fastq-trimmed-barcode16-2.3.5.fastq nanopore_rep3.hbv_hep3b.no_taps.fastq
ln -s rep3/fastq-trimmed/fastq-trimmed-barcode17-2.3.5.fastq nanopore_rep3.hbv_huh1.taps.fastq
ln -s rep3/fastq-trimmed/fastq-trimmed-barcode18-2.3.5.fastq nanopore_rep3.hbv_huh1.no_taps.fastq

grep bind rep3_hpv.primer.txt |sed 's/F\t/F /g'|cut -f1,2|sed 's/ /_/g'|awk 'BEGIN{OFS="\t"}{print ">"$1"\n"$2}' >rep3_hpv.primer.fasta
blastn -task blastn-short -db 7513-wtA-Consensus20.fa -query rep3_hpv.primer.fasta -outfmt 6|\
sort -k1,1 -k12,12nr -k11,11n|sort -k1,1 -u --merge|awk '{if($9<$10)print $2,$9,$10,$1;else print $2,$10,$9,$1}'|\
 sed 's/_primer_bind//g' >rep3_hpv.primer.bed
sed 's/^/>/g;s/\t/\n/g' rep3_mESC.primer.txt >rep3_mESC.primer.fa
blastn -task blastn-short -db mm9_genome.fa -query rep3_mESC.primer.fa -outfmt 6|\
 sort -k1,1 -k12,12nr -k11,11n|awk '($2=="chr13" &&$9>101123170)||$2=="chr11"'|\
 sort -k1,1 -u --merge|awk '{if($9<$10)print $2,$9,$10,$1;else print $2,$10,$9,$1}' \
 >rep3_mESC.primer.bed






