
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
WORKDIR=/users/ludwig/cfo155/cfo155/longReads/processed
cd $WORKDIR

# ##### methylation on 4kb #####
# BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA'
# ccgg=resource/4kb.ccgg.bed
# for bc in $BARCODES
# do
#     echo $bc `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' ) \
#     -b $ccgg -wa -wb |\
#     awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}'` \  # overlap with ccgg
#     `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' ) \
#     -b $ccgg -v|\
#     awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}'`  # non-overlap with ccgg
#     tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' >processed/${bc}.bedgraph
# done
# ##### methylation on lambda #####
# BARCODES='nanopore_rep2.lambda.ccgg.no_taps nanopore_rep2.lambda.ccgg.taps'
# ccgg=resource/lambda.ccgg.bed
# for bc in $BARCODES
# do
#     echo $bc `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "J02459.1",$1,$1+1,$2}' ) \
#     -b $ccgg -wa -wb |sed '$d'|\
#     awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}' ` \ # overlap with ccgg
#     `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' ) \
#     -b $ccgg -v|\
#     awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}'`  # non-overlap with ccgg
#     tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "J02459.1",$1,$1+1,$2}' >processed/${bc}.bedgraph
# done
# 
# ##### methylation on chr11 #####
# BARCODES='nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.chr11 nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11'
# for bc in $BARCODES
# do
#     tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "chr11",$1,$1+1,$2}' >processed/${bc}.bedgraph
# done
# 
# ##### methylation on chr13 #####
# BARCODES='nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.chr13 nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13'
# for bc in $BARCODES
# do
#     tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "chr13",$1,$1+1,$2}' >processed/${bc}.bedgraph
# done
# 
# ##### methylation on taps & wgbs ####
# 
# ##### methylation on hpv #####
# BARCODES='nanopore_rep2.hbv_percent_1.no_taps nanopore_rep2.hbv_percent_1.taps nanopore_rep2.hbv_percent_20.no_taps nanopore_rep2.hbv_percent_20.taps'
# for bc in $BARCODES
# do
#     tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "7513-wtA-Consensus20",$1,$1+1,$2}' >processed/${bc}.bedgraph
# done
# 
##### find whether pacbio get more insertion on mCG #####
# BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA'
# for bc in $BARCODES
# do
#     echo $bc
#     n=`header $bc.read.CG.details.xls |wc -l`
#     for i in `seq -s ' ' 21 4 $n`
#     do
#     cut -f${i} $bc.read.CG.details.xls |sort |uniq -c |grep -v noI |\
#         sed 's/^ \+//g'|sed 's/ /\t/g;s/$/\t/g'|tr -d '\n'|awk 'BEGIN{OFS="\t"}{gsub("pos|_ins","",$4);print "4kb",$4,$4+1, $1}'
#     done |awk 'BEGIN{FS="\t";OFS="\t"}{if($2!="")print $0}' >$bc.insertion.bedgraph
#     for i in `seq -s ' ' 21 4 $n`
#     do 
#         j=`echo "$i-2"|bc`
#         cut -f${j},${i} $bc.read.CG.details.xls |sort |uniq -c |grep -v noI |grep CG |\
#         sed 's/^ \+//g'|sed 's/ /\t/g;s/$/\t/g'|awk 'BEGIN{OFS="\t"}{gsub("pos|:CG","",$2);print "4kb",$2,$2+1,$1}'
#     done |awk 'BEGIN{FS="\t";OFS="\t"}{if($2!="")print $0}' >$bc.insertion.CG.bedgraph
# done >detailsxls.insertion.log 2>&1 

##### Find insertion with mpileup #####
# case1: A sequence block with exact the same sequence tends to have more insertion 
# case2: mCG sites also tends to have more insertions
BARCODES='nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA' # nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh
for bc in $BARCODES
do
    echo $bc
    tail -n +2 $bc.read.CG.details.xls |cut -f1 >$bc.selread.id.temp
    samtools view -H $bc.bam >$bc.bam.header

    samtools view $bc.bam |\
    awk 'BEGIN{OFS="\t"}{if($2==0||$2==16)print $0}'|\
    grep -w -f $bc.selread.id.temp |\
    cat $bc.bam.header - |\
    samtools view -bS - >$bc.sel.bam
    
    rm $bc.selread.id.temp $bc.bam.header -rf

    samtools mpileup $bc.sel.bam >$bc.mpileups.info
    
    cat $bc.mpileups.info|cut -f2,5 |\
    awk 'BEGIN{OFS="\t"}{gsub("[a-z]|[A-Z]|[0-9]|*|]|\\^|-|\\[|\\$|\"","",$2);print length($2),$0}'|\
    sort -k1,1nr |awk 'BEGIN{OFS="\t"}{print "4kb",$2,$2+1,$1}' |sort -k1,1 -k2,2n >$bc.mpileups.insertion.bedgraph

done >mpileups.insertion.log 2>&1 

##### Find correlation between longreads & taps/wgbs ##### 
for longReadsMeth in nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11.bedgraph nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13.bedgraph
do
    # treat CpG as group
    # get mC/uC count in wgbs
    # replace non-covered with 0
    # get mC/uC count in taps
    # replace non-covered with 0
    # average CpG group
    intersectBed -a <(awk 'BEGIN{OFS="\t"}{print $1,$2,$3+1,$4}' $longReadsMeth )\
         -b <(awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$5,$6}' ../resource/wgbs_R1_val_1_bismark_bt2_pe.bismark.cov) -wao |\
         awk 'BEGIN{OFS="\t"}{if($8==".")print $1,$2,$3,$4,"0","0";else print $1,$2,$3,$4,$8,$9}' |\
         intersectBed -a - \
          -b <(awk 'BEGIN{OFS="\t"}{if(NR>1)print $1,$2,$3,$5,$6}' ../resource/taps_pub.rmdup_mCtoT_CpG.mods) -wao |\
         awk 'BEGIN{OFS="\t"}{if($7==".")print $1,$2,$3,$4,$5,$6,"0","0";else print $1,$2,$3,$4,$5,$6,$10,$11}' |\
     awk '{sum1[$1"_"$2]+=$4;sum2[$1"_"$2]+=$5;sum3[$1"_"$2]+=$6;sum4[$1"_"$2]+=$7;sum5[$1"_"$2]+=$8;count[$1"_"$2]+=1}
     END{for(i in sum1)print i,sum1[i]/count[i],sum2[i]/count[i],sum3[i]/count[i],sum4[i]/count[i],sum5[i]/count[i]}'|\
         sed 's/_/\t/g;s/ /\t/g' |sort -k1,1 -k2,2n |awk 'BEGIN{OFS="\t"}{print $1,$2,$3,$4,$4+$5,$6,$6+$7}' |\
     sed 1i"chr\tpos\tlongread\tmC_wgbs\taC_wgbs\tmC_taps\taC_taps" >${longReadsMeth/.bedgraph/}.stat.txt 
done





