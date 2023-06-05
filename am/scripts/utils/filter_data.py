#!/usr/bin/python
import os
import sys

def check_file_exist(file_path):
    if not os.path.isfile(file_path):
        print '[Error] %s do not exist!' % file_path
        return False
    else:
        return True

def get_utt_set(utt_file):
    utt_set = set()
    with open(utt_file, 'r') as fp:
        for line in fp:
            item = line.strip()
            utt_set.add(item)
    return utt_set

def write_list(data_list, save_file):
    with open(save_file, 'w') as fp:
        for data in data_list:
            fp.write(data)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print 'usage:%s\tutt_file data_dir target_dir.' % sys.argv[0]
        exit(1)

    utt_file = sys.argv[1]
    data_dir = sys.argv[2]
    target_dir = sys.argv[3]

    text_file = os.path.join(data_dir, 'text')
    feats_file = os.path.join(data_dir, 'feats.scp')
    target_text_file = os.path.join(target_dir, 'text')
    target_feats_file = os.path.join(target_dir, 'feats.scp')

    if check_file_exist(text_file) and check_file_exist(feats_file):
        utt_set = get_utt_set(utt_file)
        text_list = []
        feats_list = []

        with open(text_file, 'r') as fp:
            for line in fp:
                items = line.strip().split(' ')
                if len(items) < 2:
                    continue
                else:
                    if items[0] in utt_set:
                        text_list.append(line)

        with open(feats_file, 'r') as fp:
            for line in fp:
                items = line.strip().split(' ')
                if len(items) < 2:
                    continue
                else:
                    if items[0] in utt_set:
                        feats_list.append(line)

        write_list(text_list, target_text_file)
        write_list(feats_list, target_feats_file)
        exit(0)
    else:
        print '[Error] %s or %s do not exist!' % (text_file, feats_file)
        exit(1)
