# Advent of Code: Day 1, Part 1
# DevTenga
# 09/12/2022

# https://adventofcode.com/2022/day/1

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read().split("\n\n");

	values = [sum(map(int, e.split("\n"))) for e in contents if e != '']

	m1, m2, m3 = 0,0,0

	for e in values:
		if e > m1:
			m3 = m2
			m2 = m1
			m1 = e;
		elif e > m2:
			m3 = m2
			m2 = e;
		elif e > m3:
			m3 = e;

	answers[file] = m1 + m2 + m3;

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]

