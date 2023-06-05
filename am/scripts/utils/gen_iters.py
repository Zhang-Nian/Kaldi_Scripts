#!/usr/bin/python
import sys
import collections

def generate_seq(num, interval_dict):
    result = ''
    count = 1
    for interval, val in interval_dict.items():
        for i in range(val):
            result += '%d ' % count
            count += interval
            if count > num:
                return result[:-1]
    return result[:-1]


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "usage:%s iter_num." % sys.argv[0]
        exit(1)
    num = int(sys.argv[1])
    interval_dict = {1: 5, 2: 7, 5: 5, 10: num}
    interval_dict = collections.OrderedDict(sorted(interval_dict.items()))
    print generate_seq(num, interval_dict)
    exit(0)
