
cd ../am/scripts
. ./path.sh

stage=0
if [ $# != 4 ]; then
  echo "usage:$0 train_data ali_dir network_xconfig model_dir"
  exit -1
fi
train_data=$1
ali_dir=$2
network_xconfig=$3
model_dir=$4

lang_wfst=/data/liuxueliang/work/ENV/exp/base/gmm/all.graph/lang_wfst
graph_dir="$model_dir"/graph


if [ $stage -le 1 ]; then
  train_lstm.sh $train_data $ali_dir $lang_wfst $network_xconfig $model_dir || exit -1;
fi

if [ $stage -le 2 ]; then
  test_nn.sh $lang_wfst $model_dir $graph_dir || exit -1;
fi

cd -
