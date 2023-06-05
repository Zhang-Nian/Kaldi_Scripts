
root=$1
target=$2
if [ $# != 2 ]; then
  echo "usage:$0 root target_dir"
  exit -1;
fi
cp "$root"/train_hmm_gmm.sh $target
cp "$root"/get_short_data.sh $target
cp "$root"/train_lstm.sh $target
cp "$root"/test_gmm.sh $target
cp "$root"/test_nn.sh $target
cp "$root"/steps/new_train_mono.sh $target
cp "$root"/steps/new_align_si.sh $target
cp "$root"/steps/new_train_deltas.sh $target
cp "$root"/steps/hmm_decode.sh $target
cp "$root"/steps/nn_decode.sh $target
cp "$root"/utils/mkgraph.sh $target
exit 0;
