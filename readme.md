# Introduction
This method intends to use taps to detect methylation in longreads sequencing.

# Steps

## summarize all the sequencing run
run_dataSummarize.sh 

## reference & cg position 
run_reference.sh

## map reads to reference with minimap2
run_mapping.sh

## call methylation from bam file 
> mC/(mC+uC); mC=CA+GT uC=CG

run_callMeth.sh

## summarize methylation on each sample
run_staMeth.sh

    1. caculate conversion rate based on methylated CCGG & lambda     
    2. plot methylation in mESC (compared with TAPS: both coverage & meth ratio)     
    3. Find insertion distribution in pacbio(since pacbio tends to have more insertion in mCG sites, which was exclude for methylation caculation)     

# Todo
- [ ] plot methylation in mESC
- [ ] Find insertion sites in longreads with mpileup