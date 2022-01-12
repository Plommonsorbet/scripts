import csv
import json
import sys


def __name__ == '__main__':
    data = csv.reader(sys.file, delimiter=',', quotechar='"')
    for i in data:
        print(i)
