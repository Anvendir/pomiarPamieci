#!/bin/bash

#definitions of functions

function deleteRecurringSnapshot()
{
	sed ":begin;$!N;s/snapshot=${prevSnap}\n#-----------/XXX/;tbegin;P;D" $1 | sed '/XXX/,/#-----------/d' > tmp && mv tmp $outputFileName
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
		echo "Current snapshot is: $currentSnap" >> $logFile
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

function updateSnapshotsNumeration()
{
	echo "Inside updateSnapshotsNumeration: currentSnap is $currentSnap" >> $logFile 
	snapIt=$currentSnap

	awk -v recurringSnap=$currentSnap -F = 'BEGIN { OFS = FS } $1 == "snapshot" && $2 >= recurringSnap { --$2 } 1' $outputFileName > tmp && mv tmp $outputFileName	
}

#Declaration of variables
scriptName=$(basename $0)
inputFileName=$1
outputFileName=out.parser.$$.txt
logFile="log.parser.${$}.txt"

prevMem=undefined
currentMem=undefined
snapshotsAmount=undefined
isReccuringSnapshot="true"

#colors for echo
green="\033[0;32m"
lightGray="\033[0;37m"
noColor="\033[0;39m"

#Main section

echo "$scriptName - started" | tee -a $logFile
echo "Pid is equal: $$"

countAmountOfSnapshots

while [[ "$isReccuringSnapshot" == *"true"* ]]
do
	while read line
	do
		setVariables $line

		if [[ ("$line" == *"mem_heap_B"*) && ("$prevMem" == "$currentMem") && ("$prevMem" != "undefined") ]]
		then
   			 echo "Memory usage for snapshots $prevSnap and $currentSnap are equal, their value is: $prevMem" | tee -a $logFile
		
			 isReccuringSnapshot=true	
			 deleteRecurringSnapshot $inputFileName
			 updateSnapshotsNumeration
		
			 break
		else 
			 isReccuringSnapshot=false    
    		fi

	done < $inputFileName
	
	inputFileName=$outputFileName
done

echo -e "${green}$scriptName finished successfully ${noColor}" | tee -a $logFile
echo -e "Output file: ${lightGray}$outputFileName ${noColor}" | tee -a $logFile
echo -e "Log file: ${lightGray}$logFile ${noColor}" | tee -a $logFile
