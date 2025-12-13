#!/bin/bash



myarray=("apple" "orange" "watermelon")


print_array () {
	for i in ${myarray[@]}; do

		echo $i
	done
}

print_array

