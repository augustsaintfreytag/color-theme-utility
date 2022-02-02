#! /usr/bin/env zsh

# Arguments

INPUT_FILE_NAME=$1
INPUT_BASE=$(echo "$INPUT_FILE_NAME" | sed 's/\.[^.]*$//')
OUTPUT_FILE_NAME="$INPUT_BASE.min.wasm"

if [[ "$INPUT_FILE_NAME" == "" ]]; then
	echo "Missing input file."
	exit 1
fi

# Command

cp "$INPUT_FILE_NAME" "$OUTPUT_FILE_NAME"
wasm-strip "$OUTPUT_FILE_NAME"
wasm-opt -Os "$OUTPUT_FILE_NAME" -o "$OUTPUT_FILE_NAME"