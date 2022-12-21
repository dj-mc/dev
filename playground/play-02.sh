#!/usr/bin/env bash

hello='world, $0'
# Single quotes will not expand $0
echo hello; echo $hello

double_quoted="lorem ipsum, $0"
echo $double_quoted

my_ip="IP: `ip a | grep "scope global temporary dynamic" | awk '{print $2}'`"
echo $my_ip

while true
do
    echo "What's your name?"
    read -r name

    if [ ${#name} -gt 0 ]; then
        echo "Hello, $name!"
        break
    else
        echo "Are you there?"
    fi
done

sub_str="Substring manipulations"

echo ${sub_str:0:9} # Elements 0 to 9
echo ${sub_str: -13} # Last 13 elements

# Replace 'manip' with 'congrat'
echo ${sub_str/manip/congrat}

apple="green"
banana="yellow"
cherry="red"
echo {$apple,$banana,$cherry}

echo "Create 100 files?"
read -r answer

if [[ ${answer@L} == "y" ]] || [[ ${answer@L} == "yes" ]]; then
    mkdir -p 100_files
    # Ranged brace expansion
    touch 100_files/file_{001..100}
    # Remove permissions for all filenames containing '3'
    chmod 000 100_files/*3*

    mkdir -p other_files
    # Redirect output of 'cp -v' to success or failure
    # All files with permission 000 will fail to copy
    cp -v 100_files/* other_files 1>success.txt 2>failure.txt
else
    echo "Skipping file creation"
fi
