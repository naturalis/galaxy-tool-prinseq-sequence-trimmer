#!/bin/bash

# if the input data is located in a zip file:
if [ "$1" == "zip" ]
then
	# Set read headers
	if [ "$3" == "-fastq" ]; then
		header="@"
	else
		header=">"
	fi

	# Set output extension
	ext=".fastq"
	if [ "$4" == "1" ]; then
		ext=".fasta"
	fi

	# set temp zip output file
	#temp_zip=$(mktemp -u /media/GalaxyData/database/files/XXXXXX.zip)
	#temp_zip=$(mktemp -u /home/galaxy/galaxy/database/XXXXXX.zip)
  #outlocation=$(mktemp -d /home/galaxy/galaxy/database/files/XXXXXX)
	temp_zip=$(mktemp -u /media/GalaxyData/database/files/XXXXXX.zip)
  outlocation=$(mktemp -d /media/GalaxyData/database/files/XXXXXX)
	# go through the files in the zip
	IFS=$'\n'
	for file in $(zipinfo -1 "$5")
	do
		unzip -qq -j "$5" "$file" -d $outlocation
		if [ "${file##*.}" == "gz" ]
		then
        gunzip $outlocation"/"$file
				sample="${file%.*}"
			  file="$outlocation"/"${file%.*}"
		else
	      sample="${file}"
	      file="$outlocation"/"${file}"
		fi
		IFS=$' \t\n'
		# check if the zipped file matches the selected header
		if [ $(head -n 1 $file | grep -o "^.") == "$header" ]
		then
			# set temp file for the reads
			temp=$(mktemp /media/GalaxyData/database/files/XXXXXX)
			#temp=$(mktemp /home/galaxy/galaxy/database/XXXXXX)

			# unzip the reads to the temp file, remove the temp file without the extension afterwards
			#cat "$file" | prinseq-lite.pl "$2" stdin -out_format "$3" -out_good "$temp" "${@:6}" > /dev/null 2>&1
			echo $sample":" >> $2
			cat "$file" | prinseq-lite.pl "$3" stdin -out_format "$4" -line_width 0 -out_good "$temp" "${@:7}" >> $2 2>> $2
			rm "$temp"

			# Check if the output file contains reads; if so rename the file (mv) and add it to the temp zip
			# if it doesn't contain sequences remove it.
			if [ -s "$temp$ext" ]; then
				filtered="${file%.*}_filtered$ext"
				mv "$temp$ext" "$filtered"
				zip -j -q -9 "$temp_zip" "$filtered"
				rm "$filtered"
			fi
			rm "$file"
		fi
	done
	# mv the temp zip file to the definite output file
	if [ -s "$temp_zip" ]; then
		mv "$temp_zip" "$6"
	else
		rm "$temp_zip"
	fi
# if a normal sequence file is provided
else
	echo $sample":" >> $2
	# run the prinseq lite tool with the user input
	prinseq-lite.pl "$3" "$5" -out_format "$4" -line_width 0 -out_good "$6" "${@:7}" > $2 2> $2
	# if there is an output file (i.e. not all reads have been filtered out)
	# move the output file to the galaxy path
	if [ -f "${6}".* ]; then
		mv "${6}".* "$6"
	fi
fi
rm -rf $outlocation
