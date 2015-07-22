#!/bin/bash

#definitions of functions

function deleteRecurringSnapshot()
{
	sed ":begin;$!N;s/snapshot=${prevSnap}\n#-----------/XXX/;tbegin;P;D" $1 | sed '/XXX/,/#-----------/d' > $outFileName
	echo "Snapshot $prevSnap deleted" >> $logFile

	((snapshotsAmount=$snapshotsAmount-1))
	echo "Number of snapshots is: $snapshotsAmount" >> $logFile
}

function setSnapshotVariables()
{
	if [[ ("$1" == *"snapshot"*) && ("$1" != *"desc:"*) ]]
        then
                prevSnap=$currentSnap
                currentSnap=$(echo $1 | awk -F "=" '{print $2}')
        fi
}

function setMemVarialbes()
{
	if [[ "$1" == *"mem_heap_B"* ]]
        then
	        prevMem=$currentMem
                currentMem=$(echo $1 | awk -F "=" '{print $2}')
	fi
}

function setVariables()
{
	setSnapshotVariables $1
        setMemVarialbes $1
}

function countAmountOfSnapshots()
{
	while read line
	do
        	if [[ ("$line" == *"snapshot"*) && ("$line" != *"desc:"*) ]]
        	then
               		((snapshotsAmount=$snapshotsAmount+1))
       		 fi
	done < $inputFileName

	echo "Number of snapshots is: $snapshotsAmount" >> $logFile
}

function setSnapshotNumber()
{
	while read line
        do
        	if [[ "$line" == *"snapshot=${1}"* ]]
                then
               		 sed -i -e "s/snapshot=${1}/snapshot=$((${1}-1))/" $outFileName
                fi
        done < $outFileName	
}

function updateSnapshotsNumeration()
{
	echo "Inside updateSnapshotsNumeration: currentSnap is $currentSnap" >> $logFile 
	snapIt=$currentSnap

        while [ $snapIt -le $snapshotsAmount ]
        do
                setSnapshotNumber $snapIt
	        ((snapIt=$snapIt+1))
        done	
}

#Declaration of variables

scriptName=$(basename $0)
inputFileName=$1
outFileName=parsedSnapshotsList.txt
logFile="parser.${$}.out"

prevMem=undefined
currentMem=undefined
snapshotsAmount=undefined

#Main section

echo "$scriptName - started" | tee -a $logFile

countAmountOfSnapshots

while read line
do
	setVariables $line

	if [[ ("$line" == *"mem_heap_B"*) && ("$prevMem" == "$currentMem") && ("$prevMem" != "undefined") ]]
	then
   		 echo "Wartosci zuzycia pamieci dla snapshotow $prevSnap oraz $currentSnap są równe i wynoszą: $prevMem" | tee -a $logFile
		 deleteRecurringSnapshot $inputFileName
		 updateSnapshotsNumeration    
    	fi

done < $inputFileName

echo "$scriptName finished" | tee -a $logFile
