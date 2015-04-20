#!/bin/bash

test='test'
declare -a array=('10.0.0.210' '10.0.0.220' '10.0.0.225')

test_print() {
    echo $test
}

test_array() {
    for i in "${array[@]}"
    do
       echo "$i"
    done
}

test_concat() {
    val1='Hieu'
    val2='Nguyen'
    echo "$val1@$val2"
    val1='$val1@NT89'
    echo $val1
}

test_string() {
    val1='val1'
    val2='val1'
    
    if [ $val1 = $val2 ] 
    then
    	echo "val1=val2="$val1
    fi
}

test_ls() {
	output=$(ls /home/hieun/Desktop/scripts/01 2>&1)
	if [[ $output == *"No such file or directory"* ]]
	then
		echo "OK"
	fi
}

test_variables() {
	if [[ $1 == *"test"* ]]
	then
		echo "OK test_variables"
	fi
}

test_print
test_array
test_concat
test_string
test_ls
test_variables 'test'
