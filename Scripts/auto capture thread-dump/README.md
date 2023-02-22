# Automatically Capture Thread Dumps, Usages & Heap Dump

This shell script will automatically capture Thread Dumps, Usages & Heap Dump when the average CPU usage of a WSO2 process exceeds a pre-defined threshold.

## Instructions To Run
Copy the [auto-capture.sh](auto-capture.sh) script to a directory and run using the following command.

> sh auto-capture.sh

## Required Parameters

1. Enter the time period to calculate average CPU (s):
    - Define the time period for calculating the average CPU usage in seconds. Default is 300.

2. Enter the CPU usage percentage threshold:
    - Define a threshold value for the CPU usage percentage. Default is 80.

3. Enter the required number of files:
    - Define the number of thread dumps & usages required within one round. Default is 5.

4. Enter the interval between each iteration (s):
    - Define the interval between each thread dump in seconds within one round. Default is 3.

5. Enter the frequency of running the script (s):
    - Define the frequency of running the script in seconds. Default is 60.

6. Enter the number of rounds to capture information:
    - Define the number of times the information should be captured. Default is 1.

7. Enter the process id of the WSO2 process:
    - Define the process id of the WSO2 process. If the script is placed inside the <PRODUCT_HOME> directory, process id will be auto picked from the running process.

8. Is heap dump required (y/n):
    - Define whether heap dump should be captured. Default is n (no).
