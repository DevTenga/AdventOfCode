function test() {
	if [[ "$3" = "-e" ]] ; then
		val="" 
	elif [[ -n "$3" ]] ; then
		val="$3"
	else
		val="*"
	fi

	if [[ !(-n `ls -1 "$1" | grep -i "app"`) ]]; then
		ext=`basename "$1"/app* | cut -d . -f2`
		case "$ext" in
			l | lua | Lua)
				cmd="lua";;
			py | python | Python)
				cmd="python";;
		esac
	fi

	if [ "$2" = "-s" ] ; then 
		$cmd "$1"/app.$ext "$1"/sample${val}.txt
	elif [ "$2" = "-i" ]; then
			$cmd "$1"/app.$ext "$1"/input.txt
	else
		$cmd "$1"/app.$ext "$1"/sample${val}.txt "$1"/input.txt
	fi
}

function check() {
	if [[ -n "$1" ]] ; then

		if [[ $1 -lt 10 ]] ; then
			num="0${1}"
		else
			num=$1
		fi

		if [[ -n "$2" ]] ; then
			case "$2" in

				l | lua | Lua)
					copyFile=`realpath "./.boilerplate/app.lua"`;;
				py | python | Python)
					copyFile=`realpath "./.boilerplate/app.py"`;;
			esac
		else
			copyFile=`realpath "./.boilerplate/app.lua"`
		fi

		pythonCode="
from sys import argv as a;

with open(\"$copyFile\", 'r') as f:
	code = f.read()
	print(a, a[1])
	print((f'' + code).format('{}',day = \"abc\", part=2, date=3, dir=7))
	print((f'' + code).format('{}',day=$1, part=a[1], date=\"$(date +%d/%m/%Y)\", dir=\"${PWD##*/}\"))
"

		python -c "$pythonCode" 1
	else
		echo "Internal error."
	fi
}

function init() {
	if [[ -n "$1" ]] ; then

		if [[ $1 -lt 10 ]] ; then
			num="0${1}"
		else
			num=$1
		fi

		if [[ -n "$2" ]] ; then
			case "$2" in

				l | lua | Lua)
					copyFile=`realpath "./.boilerplate/app.lua"`;;
				py | python | Python)
					copyFile=`realpath "./.boilerplate/app.py"`;;
			esac
		else
			copyFile=`realpath "./.boilerplate/app.lua"`
		fi

		pythonCode="
from sys import argv as a;

with open(\"$copyFile\", 'r') as f:
	code = f.read()
	print((f'' + code).format('{}',day=$1, part=a[1], date=\"$(date +%d/%m/%Y)\", dir=\"${PWD##*/}\"))
"

		mkdir "Day $1"
		cd "Day $1"

		mkdir "Part 1"
		cd "Part 1"
		touch sample.txt
		touch input.txt
		python -c "${pythonCode}" 1 > `basename "$copyFile"`
		cd ".."

		mkdir "Part 2"
		cd "Part 2"
		touch sample.txt
		touch input.txt
		python -c "$pythonCode" 2 > `basename "$copyFile"`
		cd ".."
		echo "Initialized ${PWD} with boilerplate `basename $copyFile`"
	else
		echo "Internal error."
	fi
}

function initnext() {
	if [[ -n "$1" ]] ; then
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
		if [[ ! -n "$ext" ]] ; then
			ext=".txt"
		fi
		touch "$adr/$name$COUNT$ext"

		COUNT=$(($COUNT + 1))
	done
}