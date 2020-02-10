id=pacbio_rep1.4kb.taps.KU

rawreads=`echo $(cat ../rawdata/$id.fastq|wc -l)/4|bc`
rawbases=`awk '{if(NR%4==2)print length($0)}' ../rawdata/$id.fastq|awk '{sum+=$0}END{print sum}'`
mappedreads=`samtools view $id.bam |awk 'BEGIN{OFS="\t"}{if($2==0||$2==16)print $1}'|sort -u |wc -l`
mappedmeanlens=`samtools view $id.bam |awk 'BEGIN{OFS="\t"}{if($2==0||$2==16)print $6}'|\
                sed 's/[0-9]*[S,H,I]//g;s/[M,D]/+/g;s/+$//g'|bc |awk '{sum+=$0}END{print sum/NR}'`
filteredlens=`wc -l $id.read.CG.details.xls`

#echo -e "id\trawreads\trawbases\tmappedreads\tmappedmeanlens\tfilteredlens"
echo -e "$id\t$rawreads\t$rawbases\t$mappedreads\t$mappedmeanlens\t$filteredlens" 
for id in 
# nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA nanopore_rep2.lambda.ccgg.no_taps nanopore_rep2.lambda.ccgg.taps nanopore_rep2.mESC_chr11_32180718_32188962.no_taps nanopore_rep2.mESC_chr11_32180718_32188962.taps nanopore_rep2.mESC_chr13_101122480_101130466.no_taps nanopore_rep2.mESC_chr13_101122480_101130466.taps nanopore_rep2.hbv_percent_20.no_taps nanopore_rep2.hbv_percent_20.taps nanopore_rep3.hbv_huh1.no_taps nanopore_rep3.hbv_huh1.taps pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA pacbio_rep2.lambda.ccgg.no_taps pacbio_rep2.lambda.ccgg.taps pacbio_rep2.mESC_chr11_32180718_32188962.4053.no_taps pacbio_rep2.mESC_chr11_32180718_32188962.4053.taps pacbio_rep2.mESC_chr13_101122480_101130466.no_taps pacbio_rep2.mESC_chr13_101122480_101130466.taps pacbio_rep2.hbv_percent_20.no_taps pacbio_rep2.hbv_percent_20.taps pacbio_rep2.hbv_huh1.no_taps pacbio_rep2.hbv_huh1.taps
do
    rawreads=`echo $(cat ../rawdata/$id.fastq|wc -l)/4|bc`
    rawbases=`awk '{if(NR%4==2)print length($0)}' ../rawdata/$id.fastq|awk '{sum+=$0}END{print sum}'`
    rawlens=`awk '{if(NR%4==2)print length($0)}' ../rawdata/$id.fastq|awk '{sum+=length($0)}END{print sum/NR}'`
    mappedreads=`samtools view $id.bam |awk 'BEGIN{OFS="\t"}{if($2==0||$2==16)print $1}'|sort -u |wc -l`
    mappedmeanlens=`samtools view $id.bam |awk 'BEGIN{OFS="\t"}{if($2==0||$2==16)print $6}'|\
                    sed 's/[0-9]*[S,H,I]//g;s/[M,D]/+/g;s/+$//g'|bc |awk '{sum+=$0}END{print sum/NR}'`
    filteredlens=`wc -l $id.*read.CG.details.xls`
    echo -e "$id\t$rawreads\t$rawbases\t$mappedreads\t$mappedmeanlens\t$filteredlens" 
done


