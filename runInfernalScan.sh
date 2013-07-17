#!/bin/bash

rfampath=/mnt/data/work/pollardlab/laurentt/rfam

${rfampath}/infernal-shattuck/bin/cmscan --tblout testInfernalTabOut.txt --verbose ${rfampath}/cm/Rfam.cm.1_1 ${rfampath}/hairpin.fa

