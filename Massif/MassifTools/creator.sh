#!/bin/bash

#definitions of functions

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

function findMemoryUsage()
{
	snapNumber=$1
	
	while read line
	do
		if [[ "$line" == *"mem_heap_B"*  ]]
		then
			echo $line > tmp.txt
			memoryUsage=$(awk -F "=" '{print $2}' tmp.txt)
			rm tmp.txt
			echo "Memory usage of snapshot $snapNumber is equal to: $memoryUsage" >> $logFile
			break			
		fi
	done < $tempFile
}

function findInstructionNumber()
{
        snapNumber=$1

        while read line
        do		
                if [[ ("$line" == *"time"*) && ("$line" != *"desc:"*) && ("$line" != *"time_unit"*) ]]
                then
                        echo $line > tmp.txt
                        instructionNumber=$(awk -F "=" '{print $2}' tmp.txt)
                        rm tmp.txt
                        echo "Instruction number for snapshot $snapNumber is equal to: $instructionNumber" >> $logFile
                        break
                fi
        done < $tempFile
}

function preapareOutputFile()
{
	snapNumber=$1
	echo "Snapshot: $snapNumber InstructionNumber: $instructionNumber TotalHeapMemory: $memoryUsage" >> $outputFileName
}

function deleteSnapshot()
{
        snapNumber=$1

        sed ":begin;$!N;s/snapshot=${snapNumber}\n#-----------/XXX/;tbegin;P;D" $tempFile | sed '/XXX/,/#-----------/d' > tmp && mv tmp $tempFile
        echo "Snapshot $snapNumber deleted" >> $logFile
}

#Declaration of variables
scriptName=$(basename $0)
logFile=log.creator.$$.txt
inputFileName=$1
outputFileName=out.creator.$$.txt
tempFile=bla
snapshotsAmount=undefined
memoryUsage=undefined
instructionNumber=undefined

#colors for echo
green="\033[0;32m"
lightGray="\033[0;37m"
noColor="\033[0;39m"
i=0

#main section

echo "$scriptName - started" | tee -a $logFile
echo "Pid is equal: $$"

cp $inputFileName $tempFile

countAmountOfSnapshots

while [[ "$i" -lt "$snapshotsAmount" ]]
do
        findMemoryUsage $i
	findInstructionNumber $i
	preapareOutputFile $i		
	deleteSnapshot $i

	((i=i+1))
done < $tempFile

rm bla

echo -e "${green}$scriptName finished successfully ${noColor}" | tee -a $logFile
echo -e "Output file: ${lightGray}$outputFileName ${noColor}" | tee -a $logFile
echo -e "Log file: ${lightGray}$logFile ${noColor}" | tee -a $logFile
