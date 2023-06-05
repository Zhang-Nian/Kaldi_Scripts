. ./cmd.sh
. ./path.sh

if [ $# != 3 ];then
  echo "usage:$0 lang_wfst_dir am_dir graph_dir"
  exit -1;
fi
lang_wfst=$1
am_dir=$2
graph_dir=$3

stage=0
test_dir=/data/vipkid_feats/test_set/fbank

test_list="good_655 mini_librispeech mini_tedium timit mixing_all mini_chatbox_90 mini_en8848 mini_voase mini_voaSplider"

if [ $stage -le 0 ]; then
  echo "start making graph, lang_wfst=$lang_wfst am_dir=$am_dir graph_dir=$graph_dir"
  utils/mkgraph.sh $lang_wfst $am_dir $graph_dir || exit -1;
  echo "finish making graph successfully!"
fi

if [ $stage -le 1 ]; then
  echo "Start decoding test set($test_list)."
  test_path_list=""
  for dset in $test_list; do
    dset_path="$test_dir"/$dset
    steps/nn_decode.sh --nj 72 --cmd "$decode_cmd" $graph_dir $dset_path $am_dir/test_${dset}
    test_path_list="${test_path_list}|${am_dir}/test_${dset}"
  done
  python wer_statistic.py "\"$test_path_list\"" "$am_dir"/all_wer
  echo "Finish decoding test set($test_list)."
fi
