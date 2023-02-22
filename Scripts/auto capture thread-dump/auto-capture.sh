#!/bin/sh

# Define the time period to calculate average CPU. Default 60
read -p "Enter the time period to calculate average CPU (s): " avg_time
avg_time=${avg_time:-60}
echo "Time period to calculate average CPU is set to: $avg_time s"

# Define the CPU usage threshold. Default 80
read -p "Enter the CPU usage percentage threshold: " cpu_threshold
cpu_threshold=${cpu_threshold:-80}
echo "CPU usage percentage threshold is set to: $cpu_threshold %"

# Define the required number of files. Default 5
read -p "Enter the required number of files: " count
count=${count:-5}
echo "Required number of files is set to: $count"

# Define the interval between each iteration. Default 3
read -p "Enter the interval between each iteration (s): " interval
interval=${interval:-3}
echo "Interval between each iteration is set to: $interval s"

# Define the frequency of running the script. Default 60
read -p "Enter the frequency of running the script (s): " frequency
frequency=${frequency:-60}
echo "Frequency of running the script is set to: $frequency s"

# Define the number of rounds to capture information. Default 1
read -p "Enter the number of rounds to capture information: " rounds
rounds=${rounds:-1}
echo "Number of rounds is set to: $rounds"

# Define the process id of the wso2 process. Default read from running process
read -p "Enter the process id of the WSO2 process: " pid
pid=${pid:-$(cat wso2carbon.pid)}
echo "Process id is set to: $pid"

# Define whether heap dump is required. Default n
read -p "Is heap dump required (y/n): " is_heap
is_heap=${is_heap:-n}
echo "Heap dump required is set to: $is_heap"
is_heap=$(echo "$is_heap" | tr '[:upper:]' '[:lower:]')

# Get the average CPU for the specified time
getAverageCPU(){
echo "Getting average CPU usage..."
TOP_OUTPUT=$(top -b -n 10 -d $((avg_time/10)) | grep $pid| awk '{print int($9)}')
CPU_SUM=0

for LINE in $TOP_OUTPUT;
do
  CPU_SUM=$(($CPU_SUM + $LINE))
done

AVG_CPU=$(awk "BEGIN { printf \"%.0f\", $CPU_SUM/10 }")
echo "Average CPU usage is $AVG_CPU %"
}

captureInfo(){
echo "********************";
echo "CPU threshold exceeded! Capturing information..."
# Create a new directory to save the files
dir_path=`date "+%F-%T"`
mkdir $dir_path

# Iterate and save thread dumps until required count is reached
for i in `seq 1 $count`;
	do
        	jstack -l $pid > $dir_path/thread_dump_`date "+%F-%T"`.txt &
        	ps --pid $pid -Lo pid,tid,%cpu,time,nlwp,c > $dir_path/thread_usage_`date "+%F-%T"`.txt &
		# Sleep for the given interval between each iteration
		if [ $i -ne $count ]; then
        		echo "sleeping for $interval s [$i]"
        		sleep $interval
		fi
	done

if [ "$is_heap" = "y" ]; then
echo "Capturing heap dump..."
jmap -dump:format=b,file=$dir_path/heapdump.hprof $pid
fi
}

while true; do
        echo "********************!!!********************";
        
        if [ $rounds -eq 0 ]; then
         echo "Number of rounds reached...Exiting..."
         exit
        fi
        
	getAverageCPU

	# Check if the CPU usage is greater than the defined threshold
	if [ $AVG_CPU -gt $cpu_threshold ]; then
        	captureInfo
        	rounds=$((rounds - 1))
	fi

	echo "********************";

	# Sleep for the given frequency
	echo "Next run in $frequency s"
	sleep $frequency
done
