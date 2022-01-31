# Advent of Code: Day {day}, Part {part}
# DevTenga
# {date}

# https://adventofcode.com/{dir}/day/{day}

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read()

	for matches in RegEx.findall(r'regex', contents):
		pass

	answer = 0

	answers[file]= answer

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]
