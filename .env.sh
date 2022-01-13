function test() {
	if [[ "$3" = "-e" ]] ; then
		val="" 
	elif [[ -n "$3" ]] ; then
		val="$3"
	else
		val="*"
	fi
	
	if [ "$2" = "-s" ] ; then 
		lua "$1"/app.lua "$1"/sample${val}.txt
	elif [ "$2" = "-i" ]; then
			lua "$1"/app.lua "$1"/input.txt
	else
		lua "$1"/app.lua "$1"/sample${val}.txt "$1"/input.txt
	fi
}

function check() {
	if [[ -n "$1" ]] ; then
		echo true
	else
		echo false
	fi

	if [[ $1 -lt 10 ]] ; then
		num="0${1}"
	else
		num=$1
	fi

	echo -e "-- Advent of Code: Day ${1}, Part 1\n-- DevTenga\n-- `date +%d/%m/%Y`\n\n-- https://adventofcode.com/${PWD##*/}/day/$1\n\nfor _,file in ipairs(arg) do\n\tlocal contents = io.open(file):read(\"*all\")\n\n\tfor _ in string.gmatch(contents,\"regex\") do\n\t\t\n\tend\n\n\tlocal answer = 0\n\n\tprint(\"For File:\",file,\"Answer is:\",answer)\nend"
}

function init() {
	if [[ -n "$1" ]] ; then

		if [[ $1 -lt 10 ]] ; then
			num="0${1}"
		else
			num=$1
		fi

		msg1="-- Advent of Code: Day ${1},Part 1\n-- DevTenga\n-- `date +%d/%m/%Y`\n\n-- https://adventofcode.com/${PWD##*/}/day/$1\n\nfor _,file in ipairs(arg) do\n\tlocal contents = io.open(file):read(\"*all\")\n\n\tfor _ in string.gmatch(contents,\"regex\") do\n\t\t\n\tend\n\n\tlocal answer = 0\n\n\tprint(\"For File:\",file,\"Answer is:\",answer)\nend"
		msg2="-- Advent of Code: Day ${1},Part 2\n-- DevTenga\n-- `date +%d/%m/%Y`\n\n-- https://adventofcode.com/${PWD##*/}/day/$1\n\nfor _,file in ipairs(arg) do\n\tlocal contents = io.open(file):read(\"*all\")\n\n\tfor _ in string.gmatch(contents,\"regex\") do\n\t\t\n\tend\n\n\tlocal answer = 0\n\n\tprint(\"For File:\",file,\"Answer is:\",answer)\nend"				

		mkdir "Day $1"
		cd "Day $1"

		mkdir "Part 1"
		cd "Part 1"
		touch sample.txt
		touch input.txt
		echo -e "$msg1" > app.lua
		cd ".."

		mkdir "Part 2"
		cd "Part 2"
		touch sample.txt
		touch input.txt
		echo -e "$msg2" > app.lua
		cd ".."

		cd ".."
	else
		echo "Internal error."
	fi
}

function initnext() {
	if [[ "$1" != " " && -n "$1" ]] ; then
		cp "$1/Part 1"/* "$1/Part 2"
	fi
}

function ntouch()  {
	adr=$1
	name=$2
	count=$3
	ext=$4

	COUNT=1

	while [[ $COUNT -le $count ]]; do
		if [[ "$ext" = " " || ! -n "$ext" ]] ; then
			ext=".txt"
		fi
		touch "$adr/$name$COUNT$ext"

		COUNT=$(($COUNT + 1))
	done
}