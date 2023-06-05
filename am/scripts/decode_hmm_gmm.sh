. ./cmd.sh
. ./path.sh

decode_graph=$1
target_dir=$2

if [ $# != 2 ]; then
  echo "usage:$0 decode_graph target_dir."
  exit -1;
fi

test_dir=/data/vipkid_feats/test_set/mfcc_pitch/
test_list="mini_librispeech mini_tedium timit good_655 chatbox_100"

for test_name in $test_list; do
  steps/hmm_decode.sh $decode_graph "$test_dir"/"$test_name" "$target_dir"/decode_"$test_name"
done
