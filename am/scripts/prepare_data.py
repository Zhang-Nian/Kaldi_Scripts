#coding:utf-8

import os
import sys

def check_file_exist(wav_dir_path, wav_text_file, wav_list_file):
    if not os.path.isdir(wav_dir_path):
        print '[Error] wav_dir:%s do not exist!' % wav_dir_path
        return False
    elif not os.path.isfile(wav_text_file):
        print '[Error] wav_text:%s do not exist!' % wav_text_file
        return False
    elif not os.path.isfile(wav_list_file):
        print '[Error] wav.list:%s do not exist' % wav_list_file
        return False
    else:
        print '[Info] success.wav_dir, wav_text, wav.list exist.'
        return True

def gen_wav_scp_text(wav_dir_path, wav_text_file, wav_list_file, save_path):
    wav_set = set()
    for wav_name in os.listdir(wav_dir_path):
        wav_path = os.path.join(wav_dir_path, wav_name)
        wav_set.add(wav_path)

    wav2text = {}
    with open(wav_text_file, 'r') as fp:
        for line in fp:
            sections = line.strip('\n').split('\t')
            if len(sections) == 2:
                wav_path, wav_text = sections
                wav2text[wav_path] = wav_text
    wav_scp = []
    text_list = []
    with open(wav_list_file, 'r') as fp:
        for line in fp:
            wav_path = line.strip()
            if wav_path not in wav_set:
                print '[Error] wav:%s do not exist in war_dir:%s' % (wav_path, wav_dir_path)
                exit(1)
            elif not wav2text.has_key(wav_path):
                print '[Error] wav:%s do not exist in wav_text' % wav_path
                exit(1)
            else:
                wav_scp.append('%s %s\n' % (wav_path, wav_path))
                text_list.append('%s %s\n' % (wav_path, wav2text[wav_path]))

    wav_scp_file = os.path.join(save_path, 'wav.scp')
    text_file = os.path.join(save_path, 'text')

    with open(wav_scp_file, 'w') as fp:
        for item in wav_scp:
            fp.write(item)

    with open(text_file, 'w') as fp:
        for item in text_list:
            fp.write(item)


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "usage:python data_prepare.py wavdir"
        sys.exit(1)
    file_path = sys.argv[1]
    wav_dir_path = os.path.join(file_path, 'wav_dir')
    wav_list_file = os.path.join(file_path, 'wav.list')
    wav_text_file = os.path.join(file_path, 'wav_text')
    if not check_file_exist(wav_dir_path, wav_text_file, wav_list_file):
        exit(1)
    else:
        gen_wav_scp_text(wav_dir_path, wav_text_file, wav_list_file, file_path)
        exit(0)
