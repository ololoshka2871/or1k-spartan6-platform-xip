#!/usr/bin/env python
# coding: utf-8

import sys
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--basefile","-b",type=str, help="Базовый файл", required=True)
    parser.add_argument("--importfile","-i",type=str, help="Импортируемый файл", required=True)
    parser.add_argument("--offset",type=lambda x: int(x,0), help="Смещение (если не в конец базового файла)",
        default=-1)

    args = parser.parse_args()
    print (args.offset)

    base_data = open(args.basefile, 'rb').read()
    import_data = open(args.importfile, 'rb').read()

    if (args.offset == -1):
        sys.stdout.buffer.write(base_data)
        sys.stdout.buffer.write(import_data)
    else:
        if (args.offset > len(base_data)):
            sys.stdout.buffer.write(base_data)
            sys.stdout.buffer.write(bytearray(args.offset - len(base_data)))
            sys.stdout.buffer.write(import_data)
        else:
            sys.stdout.buffer.write(base_data[:args.offset])
            sys.stdout.buffer.write(import_data)
            if (args.offset + len(import_data) < len(base_data)):
                sys.stdout.buffer.write(base_data[args.offset + len(import_data):])
    sys.stdout.flush()

# чтобы при импорте не выполнялся код автоматом
if __name__ == '__main__':
    main()
