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
