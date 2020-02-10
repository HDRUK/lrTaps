# Introduction
A tool developed for analyzing CG methylation from targeted long-read Tet-assisted pyridine borane sequencing (lrTAPS).

# Steps

## 0. summarize the details of all sequencing run
run_dataSummarize.sh 

## 1. prepare reference sequence & cg position 
run_reference.sh

## 2. map reads to reference with minimap2
run_mapping.sh

## 3. call methylation from bam file 

run_callMeth.sh

$$methylation\_percentage = \frac{mC}{mC+uC}$$

$$mC = CA + GT$$ 

$$uC = CG$$


