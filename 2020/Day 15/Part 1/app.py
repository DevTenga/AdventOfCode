# Advent of Code: Day 15, Part 1
# DevTenga
# 01/02/2022

# https://adventofcode.com/2020/day/15

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read()

	turns = [None]
	lastOccurences = {}
	idx = 1
	nextNum = None

	for match in RegEx.findall(r'(\d+)', contents, flags=RegEx.M):
		turns.append(match);
		lastOccurences[match] = (None, idx);
		idx += 1;
	
	# Debugging
	# print(turns, lastOccurences)

	for idx in range(idx, 2021):
		lastNum = str(turns[idx - 1])
		# Debugging
		# print(f"At idx {idx - 1} num is {lastNum}:")
		
		tup = lastOccurences[lastNum]
		tupIdx = ''
		if tup[0]:
			turns.append(tup[1] - tup[0])
			tupIdx = str(tup[1] - tup[0])

		else:
			turns.append(0)
			tupIdx = '0'

		try:
			lastOccurences[tupIdx] = (lastOccurences[tupIdx][1], idx)
		except KeyError:
			lastOccurences[tupIdx] = (None, idx)


	answer = turns[2020]

	answers[file] = answer

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]

