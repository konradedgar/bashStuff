#!/usr/bin/env sh

######################################################################
# @author      : Konrad
# @file        : convert_ffmpeg_for_tv
# @created     : Friday Mar 01, 2019 16:07:53 CET
# @license     : GPL-3.0
#
# @description : Run two pass conversion to convert file to tv
######################################################################


# Take input files as variables
if [ "$#" -eq 0 ]; then
  exit "Did not receive any files"
else
  input_files=( "$@" )
fi

# Apply conversion to each file received in the array
for input_file in "${input_files[@]}"
do
	if [ -e "$input_file" ]; then
		# Create converted file name
		base_name="${input_file%%.*}"
		output_file="${base_name}.avi"
		# Show file paths with orizontal line before and after
		# Horizontal line code: https://wiki.bash-hackers.org/snipplets/print_horizontal_line#a_line_across_the_entire_width_of_the_terminal
		printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
		echo "Received file: ${input_file}."
		echo "Will create: ${output_file}."
		printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -

		# Run ffmpeg with desired switches converting file
		# First pass
		ffmpeg 	-y 			\
			-i "${input_file}" 	\
			-c:v mpeg4 		\
			-b:v 868k 		\
			-tag:v DIVX 		\
			-an 			\
			-pass 1 		\
			-f rawvideo /dev/null
		# Run second ffmpeg pass
		ffmpeg -i "${input_file}" 	\
			-c:v mpeg4 		\
			-b:v 868k 		\
			-tag:v DIVX 		\
			-c:a libmp3lame 	\
			-b:a 192k 		\
			-ac 2 			\
			-ar 44100 		\
			-pass 2 "${output_file}"
		echo "Created: ${output_file}"
	else 
		echo "File: $input_file does not exist"
	fi 
done
