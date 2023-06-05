
cd ../am/scripts
. ./path.sh

if [ $# != 2 ];then
  echo "usage:$0 feats_dir target_models"
  exit -1;
fi

stage=0

feats_dir=$1
target_models=$2

lang=/data/liuxueliang/work/ENV/exp/base/gmm/all.graph/lang
lang_wfst=/data/liuxueliang/work/ENV/exp/base/gmm/all.graph/lang_wfst

graph_dir="$target_models"/graph

if [ $stage -le 0 ]; then
  train_hmm_gmm.sh $feats_dir $lang $target_models || exit -1;
fi

if [ $stage -le 1 ]; then
  test_gmm.sh $lang_wfst $target_models $graph_dir || exit -1;
fi

cd -
