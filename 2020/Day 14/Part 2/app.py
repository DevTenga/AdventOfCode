# Advent of Code: Day 14, Part 2
# DevTenga
# 31/01/2022

# https://adventofcode.com/2020/day/14

from sys import argv as arg;
import re as RegEx

answers = {}

for file in arg[1:]:
	contents = open(file, 'r').read()

	masks = []
	maskl = ~0
	mem = {}

	for matches in RegEx.findall(r'([\w\[\]]+)\s*=\s*([\dX]+)', contents):
		if matches[0] == "mask":
			maskl = int(matches[1].replace('X', '1'), 2)		
			masks = [matches[1]]
			_masks = []
			while masks[0].find('X') >= 0:
				for mask in masks:
					_masks.append(mask.replace('X','0',1))  
					_masks.append(mask.replace('X','1',1))
				masks = _masks
				_masks = []
			# Debugging
			# exit(0)  
			# print(f'New masks are: \nm = {mask:036b}\nl = {maskl:036b}')
		elif (assign := RegEx.search(r'mem\[(\d+)\]', matches[0])):
			num = int(matches[1])
			idx = int(assign.group(1))
			rest = idx & ~maskl			

			for mask in masks:
				mem[str(rest | int(mask, 2))] = num

	answer = sum(mem.values())

	answers[file]= answer

print('''

================================================================
================================================================
''')
print("For File","Answer is\n===============","===============", sep = '\t\t')
[print(file, answer, sep = '\t\t') 
for file,answer in answers.items()]

