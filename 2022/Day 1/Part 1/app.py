# Advent of Code: Day 1, Part 1
# DevTenga
# 09/12/2022

# https://adventofcode.com/2022/day/1

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read().split("\n\n");

	answer = max( [sum(map(int, e.split("\n"))) for e in contents if e != ''])

	answers[file]= answer

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]

