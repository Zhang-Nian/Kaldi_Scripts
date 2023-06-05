. ./cmd.sh
. ./path.sh

if [ $# != 3 ];then
  echo "usage:$0 feats_dir lang_dir target_models."
  exit -1;
fi

stage=0

feats_dir=$1
lang=$2
target_models=$3


nj=11

train_num=$(wc -l "$feats_dir"/feats.scp | cut -d ' ' -f 1)
short_num=$[train_num/3]

mono_train_data=$target_models/train_short"$short_num"
mono_models=$target_models/mono
mono_ali=$target_models/mono_ali

[ ! -d $feats_dir ] && echo "$0: no such directory $feats_dir" && exit 1;

if [ $stage -le 0 ]; then
  [ -d $target_models ] && echo "$0:target models $target_models exist!" && exit 1;
  mkdir -p $target_models || exit 1;
  run_root=$(dirname $0)
  target_src=$target_models/src
  mkdir -p $target_src || exit 1;
  backup_src.sh $run_root $target_src || exit 1;
  echo "Finish backup source."
  get_short_data.sh $short_num $feats_dir $mono_train_data || exit 1;
  echo "Finish getting short data for training mono."
fi


if [ $stage -le 1 ]; then
  echo "Start training mono models."
  steps/new_train_mono.sh --nj $nj --cmd "$train_cmd" $mono_train_data $lang $mono_models || exit 1;
  echo "Finish training mono models."
fi

if [ $stage -le 2 ]; then
  echo "Start aligning train data by mono models."
  steps/new_align_si.sh --nj $nj --cmd "$train_cmd" $feats_dir $lang $mono_models $mono_ali || exit 1;
  echo "Finish aligning train data by mono models."
fi

if [ $stage -le 3 ]; then
  echo "Start training hmm-gmm."
  steps/new_train_deltas.sh --cmd "$train_cmd" 10000 200000 $feats_dir $lang $mono_ali $target_models || exit 1;
  echo "Successfully finish training hmm-gmm!"
fi

