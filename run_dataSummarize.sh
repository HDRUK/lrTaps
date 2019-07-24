## first Nanopore sequencing
# mkdir fastq-binned-2.3.5_rmdup 
# for i in `ls fastq-binned-2.3.5/*`
# do
# 	cat $i |paste - - - - |sort -k1,1 |sort -u --merge |sed 's/\t/\n/g' >`echo $i |sed 's/fastq-binned-2.3.5/fastq-binned-2.3.5_rmdup/g'`
# done
# /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC04.fastq
# /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC02.fastq
# /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC01.fastq
# /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC05.fastq
# /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/none.fastq

##### Nanopore rep1 #####
## on 4kb 
# Nanopore 4 kb TAPS LA
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC04.fastq nanopore_rep1.4kb.taps.LA.fastq
# Nanopore 4 kb TAPS KU
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC05.fastq nanopore_rep1.4kb.taps.KU.fastq
# 4 kb PCR
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC01.fastq nanopore_rep1.4kb.nometh.fastq
# Nanopore native methylation calling
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/native_methycalling/fastq-binned-2.3.5_rmdup/BC02.fastq nanopore_rep1.4kb.ccgg.meth.fastq

##### Pacbio rep1 #####
## on 4kb 
# pacbio 4 kb TAPS LA
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/pacbio/TAPS/TAPS_LA/m54019_190522_215456.Q20.fastq pacbio_rep1.4kb.taps.LA.fastq
# pacbio 4 kb TAPS KU 
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/pacbio/TAPS/TAPS_KU/m54019_190522_215456.Q20.fastq pacbio_rep1.4kb.taps.KU.fastq
# pacbio 4 kb control
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/pacbio/TAPS/control/m54019_190522_215456.Q20.fastq pacbio_rep1.4kb.nometh.fastq

##### Nanopore rep1 #####
## on hbv cccDNA
# 13 30/5 HBV 1% 20 ng LA
# 14 30/5 HBV 20% 20 ng LA
# 15 3/6 1% TAPS LA
# 16 3/6 20% TAPS LA
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode13-2.3.5.fastq nanopore_rep2.hbv_percent_1.no_taps.fastq
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode14-2.3.5.fastq nanopore_rep2.hbv_percent_20.no_taps.fastq
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode15-2.3.5.fastq nanopore_rep2.hbv_percent_1.taps.fastq
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode16-2.3.5.fastq nanopore_rep2.hbv_percent_20.taps.fastq

## on mESC
# 17 4053 TAPS LA
# 19 4053 LA
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode17-2.3.5.fastq nanopore_rep2.mESC_chr11_32180718_32188962.taps.fastq
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode19-2.3.5.fastq nanopore_rep2.mESC_chr11_32180718_32188962.no_taps.fastq

# 20 4/6 mESC TAPS 4407
# 21 3/6 4407 LA
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode20-2.3.5.fastq nanopore_rep2.mESC_chr13_101122480_101130466.taps.fastq
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode21-2.3.5.fastq nanopore_rep2.mESC_chr13_101122480_101130466.no_taps.fastq

## on lambda
# 22 Lambda 10135 TAPS
# 23 Lambda 10135 Ctrl
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode22-2.3.5.fastq nanopore_rep2.lambda.ccgg.taps.fastq
ln -s /users/ludwig/cfo155/cfo155/ontTaps/data/hbv_run/fastq/fastq-trimmed-barcode23-2.3.5.fastq nanopore_rep2.lambda.ccgg.no_taps.fastq


