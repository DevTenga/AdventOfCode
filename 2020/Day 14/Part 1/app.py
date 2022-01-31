# Advent of Code: Day 14, Part 1
# DevTenga
# 31/01/2022

# https://adventofcode.com/2020/day/14

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read()

	mask = 0
	maskl = ~0
	mem = {}

	for matches in RegEx.findall(r'([\w\[\]]+)\s*=\s*([\dX]+)', contents):
		if matches[0] == "mask":
			mask = int(matches[1].replace('X', '0'), 2)
			maskl = int(matches[1].replace('0', '1').replace('X', '0'), 2)
			# Debugging
			# print(f'New masks are: \nm = {mask:036b}\nl = {maskl:036b}')
		elif (assign := RegEx.search(r'mem\[(\d+)\]', matches[0])):
			num = int(matches[1])
			rest = num & ~maskl
			mem[assign.group(1)] = rest | mask
			# Debugging
			# print(f'New number is {rest | mask}. (Original: {num})') 

	answer = sum(mem.values())

	answers[file]= answer

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]

