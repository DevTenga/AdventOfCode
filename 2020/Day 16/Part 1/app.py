# Advent of Code: Day 16, Part 1
# DevTenga
# 08/02/2022

# https://adventofcode.com/2020/day/16

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read().split("\n\n")

	ranges = set()

	for matches in RegEx.findall(r'(\d+)\-(\d+)', contents[0]):
		ranges.update(set(range(int(matches[0]), int(matches[1]) + 1)))

	ticketVals = list(map(int, contents[2].split(':')[1][1:].replace('\n',',').split(',')))

	print(ticketVals)

	answer = sum([a for a in ticketVals if not a in ranges])

	answers[file]= answer

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]

