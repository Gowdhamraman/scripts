#!/bin/bash

# Check if a number is provided as an argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number_of_files>"
    exit 1
fi

# Assign the first argument to a variable
NUMBER_OF_FILES=$1

# Check if the argument is a positive integer
if ! [[ "$NUMBER_OF_FILES" =~ ^[0-9]+$ ]]; then
    echo "Error: Please provide a positive integer."
    exit 1
fi

# Create the specified number of files
for ((i=1; i<=NUMBER_OF_FILES; i++)); do
    FILENAME="file$i.txt"
    touch "$FILENAME"
    echo "Created $FILENAME"
done

echo "Successfully created $NUMBER_OF_FILES files."
