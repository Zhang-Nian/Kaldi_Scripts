import os
import sys

if __name__ == "__main__":
    test_path_list_str = sys.argv[1]
    all_wer_file = sys.argv[2]
    test_path_list = test_path_list_str[1:-1].split("|")
    test_list = []
    wer_list = []
    for test_path in test_path_list:
        if test_path:
            wer_file = test_path + "/scoring_kaldi/best_wer"
            test_name = os.path.basename(test_path)
            test_list.append(test_name)
            with open(wer_file, 'r') as fp:
                content = fp.readline()
                wer = content.split(" ")[1]
                wer_list.append(wer)

    with open(all_wer_file, 'w') as fp:
        test_name_str = "\t".join(test_list)
        all_wer_str = "\t".join(wer_list)
        fp.write(test_name_str + "\n")
        fp.write(all_wer_str + "\n")
