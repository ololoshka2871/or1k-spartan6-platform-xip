#!/usr/bin/env python3
# coding: utf-8
# пиши, бля, u"Юникод_строка"

import sys, re

ma = { 'default': 0, '>' : 1, '<' : 2}
inv_ma = {v: k for k, v in ma.items()}

class bcolors:
	HEADER = '\033[95m'
	OKBLUE = '\033[94m'
	OKGREEN = '\033[92m'
	WARNING = '\033[93m'
	FAIL = '\033[91m'
	ENDC = '\033[0m'
	BOLD = '\033[1m'
	UNDERLINE = '\033[4m'

pattern = re.compile(r"^([<>]) (.*)")

def data_dir(s):
	m = pattern.match(s)
	if m is None:
		return (ma['default'], "")
	else:
		return (ma[m.group(1)], m.group(2))	

def main():
	state = ma['default']
	try:
		while True:
			data = sys.stdin.readline()
		
			direction, text = data_dir(data)
			if direction != state:
				if direction == ma['default']:
					sys.stdout.write(bcolors.ENDC + '\n\r---BREAK---')
					sys.stdout.flush()
					continue
				state = direction
				if direction == ma['>']:
					sys.stdout.write(bcolors.OKGREEN + '\n\r> ')
				if direction == ma['<']:
					sys.stdout.write(bcolors.FAIL + '\n\r< ')
			if len(text):
				sys.stdout.write(text)
			sys.stdout.flush()
	except KeyboardInterrupt:
		print (bcolors.ENDC + '\n\rEnd.\n\r')


# чтобы при импорте не выполнялся код автоматом
if __name__ == '__main__':
	main()
