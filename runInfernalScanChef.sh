#!/bin/bash
# This script will run Infernal on a broken up fasta file

#$ -S /bin/bash                    
#$ -o ./chefout                    
#$ -e ./chefout                    
#$ -cwd
#$ -r y
#$ -j y
#$ -l mem_free=5G
#$ -l arch=linux-x64
#$ -l netapp=1G,scratch=1G
#$ -l h_rt=336:00:00
##$ -l h_rt=00:30:00
#$ -t 1-1000         
hostname
date

outdir=./chefout/
workingdir=/netapp/home/laurentt/rfam/
rfam=cm/Rfam.cm.1_1

fastaDir=fastaStaging/
domtbloutdir="domtblout/"
cmscan=/netapp/home/laurentt/bin/bin/cmscan
# fulloutdir="./fullout/"
#L4_unclassified_reads.940.fa
cd $workingdir

qstat -j $JOB_ID

# if [ ! -d "$logdir" ]; then
#       mkdir $logdir
# fi

if [ ! -d "$outdir" ]; then
	mkdir $outdir
fi

if [ ! -d "$domtbloutdir" ]; then
	mkdir $domtbloutdir
fi

${cmscan} --tblout ${workingdir}${domtbloutdir}L4_unclassified_reads.$SGE_TASK_ID.tab.txt --verbose ${workingdir}${rfam} ${workingdir}${fastaDir}L4_unclassified_reads.$SGE_TASK_ID.fa

