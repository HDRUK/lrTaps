##### methylation on 4kb #####
BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA'
ccgg=resource/4kb.ccgg.bed
for bc in $BARCODES
do
    echo $bc `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' ) \
    -b $ccgg -wa -wb |\
    awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}'` \  # overlap with ccgg
    `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' ) \
    -b $ccgg -v|\
    awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}'`  # non-overlap with ccgg
    tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' >processed/${bc}.bedgraph
done
##### methylation on lambda #####
BARCODES='nanopore_rep2.lambda.ccgg.no_taps nanopore_rep2.lambda.ccgg.taps'
ccgg=resource/lambda.ccgg.bed
for bc in $BARCODES
do
    echo $bc `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "J02459.1",$1,$1+1,$2}' ) \
    -b $ccgg -wa -wb |sed '$d'|\
    awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}' ` \ # overlap with ccgg
    `intersectBed -a <(tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "4kb",$1,$1+1,$2}' ) \
    -b $ccgg -v|\
    awk 'BEGIN{OFS="\t"}{sum+=$4}END{print sum/NR,NR}'`  # non-overlap with ccgg
    tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "J02459.1",$1,$1+1,$2}' >processed/${bc}.bedgraph
done

##### methylation on chr11 #####
BARCODES='nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.chr11 nanopore_rep2.mESC_chr11_32180718_32188962.taps.chr11'
for bc in $BARCODES
do
    tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "chr11",$1,$1+1,$2}' >processed/${bc}.bedgraph
done

##### methylation on chr13 #####
BARCODES='nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.chr13 nanopore_rep2.mESC_chr13_101122480_101130466.taps.chr13'
for bc in $BARCODES
do
    tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "chr13",$1,$1+1,$2}' >processed/${bc}.bedgraph
done

##### methylation on taps & wgbs ####

##### methylation on hpv #####
BARCODES='nanopore_rep2.hbv_percent_1.no_taps nanopore_rep2.hbv_percent_1.taps nanopore_rep2.hbv_percent_20.no_taps nanopore_rep2.hbv_percent_20.taps'
for bc in $BARCODES
do
    tail -n +2 processed/$bc.CG.meth.xls |awk 'BEGIN{OFS="\t"}{print "7513-wtA-Consensus20",$1,$1+1,$2}' >processed/${bc}.bedgraph
done

##### find whether pacbio get more insertion on mCG #####
BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU pacbio_rep1.4kb.taps.LA'
for bc in $BARCODES
do
    n=`header $bc.read.CG.details.xls |wc -l`
    for i in `seq -s ' ' 21 4 $n`
    do
    cut -f${i} $bc.read.CG.details.xls |sort |uniq -c |grep -v noI |\
        sed 's/^ \+//g'|sed 's/ /\t/g;s/$/\t/g'|tr -d '\n'|awk 'BEGIN{OFS="\t"}{gsub("pos|_ins","",$4);print "4kb",$4,$4+1, $1}'
    done |awk 'BEGIN{FS="\t";OFS="\t"}{if($2!="")print $0}' >$bc.insertion.bedgraph
    for i in `seq -s ' ' 21 4 $n`
    do 
        j=`echo "$i-2"|bc`
        cut -f${j},${i} $bc.read.CG.details.xls |sort |uniq -c |grep -v noI |grep CG |\
        sed 's/^ \+//g'|sed 's/ /\t/g;s/$/\t/g'|awk 'BEGIN{OFS="\t"}{gsub("pos|:CG","",$2);print "4kb",$2,$2+1,$1}'
    done |awk 'BEGIN{FS="\t";OFS="\t"}{if($2!="")print $0}' >$bc.insertion.CG.bedgraph
done

##### Find insertion with mpileup #####
# case1: A sequence block with exact the same sequence tends to have more insertion 
# case2: mCG sites also tends to have more insertions
BARCODES='nanopore_rep1.4kb.ccgg.meth nanopore_rep1.4kb.nometh nanopore_rep1.4kb.taps.KU nanopore_rep1.4kb.taps.LA pacbio_rep1.4kb.nometh pacbio_rep1.4kb.taps.KU'  # 'pacbio_rep1.4kb.taps.LA'
for bc in $BARCODES
do
    samtools view $bc.bam |grep -w -f <(tail -n +2 $bc.read.CG.details.xls |cut -f1 ) |\
    cat <(samtools view -H $bc.bam) - |samtools view -bS - >$bc.sel.bam
    samtools mpileup $bc.sel.bam >$bc.mpileups.info
    cat $bc.mpileups.info|cut -f2,5 |\
    awk 'BEGIN{OFS="\t"}{gsub("[a-z]|[A-Z]|[0-9]|*|]|\\^|-|\\[|\\$|\"","",$2);print length($2),$0}'|\
    sort -k1,1nr |awk 'BEGIN{OFS="\t"}{print "4kb",$2,$2+1,$1}' |sort -k1,1 -k2,2n >$bc.mpileups.insertion.bedgraph
done





