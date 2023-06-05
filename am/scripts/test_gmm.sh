. ./cmd.sh
. ./path.sh

if [ $# != 3 ];then
  echo "usage:$0 lang_wfst_dir am_dir graph_dir"
  exit -1;
fi

lang_wfst=$1
am_dir=$2
graph_dir=$3

stage=-1
test_dir=/data/vipkid_feats/test_set/mfcc_pitch

test_list="good_655 mini_librispeech mini_tedium timit mixing_all mini_chatbox_90 mini_en8848 mini_voase mini_voaSplider"

if [ $stage -le 0 ]; then
  echo "Starting making hmm-gmm graph."
  ./utils/mkgraph.sh $lang_wfst $am_dir $graph_dir
  echo "Finish making hmm-gmm graph."
fi

if [ $stage -le 1 ]; then
  echo "Start decoding test sets($test_list)."
  test_path_list=""
  for test_name in $test_list; do
    steps/hmm_decode.sh $graph_dir "$test_dir"/"$test_name" "$am_dir"/test_"$test_name"
    test_path_list="${test_path_list}|${am_dir}/test_${test_name}"
  done
  python wer_statistic.py "\"$test_path_list\"" "$am_dir"/all_wer
  echo "Finish decoding test sets($test_list)."
fi
