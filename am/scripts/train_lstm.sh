. ./cmd.sh
. ./path.sh

if [ $# != 5 ];then
  echo "usage:$0 train_data_dir ali_dir lang_dir xconfig_file model_dir"
  exit -1;
fi

stage=0
num_epochs=15

train_data=$1
ali_dir=$2
lang=$3
network_xconfig=$4
model_dir=$5


# LSTM options
train_stage=-10
label_delay=5

# training chunk-options
chunk_width=40
chunk_left_context=20
chunk_right_context=0

# training options
srand=2
remove_egs=true

# you can set egs dir if you already have generated egs

common_egs_dir=
model_init=

if [ $stage -le 1 ]; then
  echo "Start generating network config."
  steps/nnet3/xconfig_to_configs.py  --xconfig-file $network_xconfig --config-dir $model_dir/configs || exit 1;
  echo "Finish generating network config successfully!"
fi

if [ $stage -le 2 ]; then
  echo "Starting training LSTM."
  steps/nnet3/train_rnn_new.py --stage=$train_stage \
    --cmd="$decode_cmd" \
    --trainer.srand=$srand \
    --trainer.max-param-change=2.0 \
    --trainer.num-epochs=$num_epochs \
    --trainer.num-epochs=6 \
    --trainer.input-model=$model_init \
    --trainer.deriv-truncate-margin=10 \
    --trainer.samples-per-iter=20000 \
    --trainer.optimization.num-jobs-initial=4 \
    --trainer.optimization.num-jobs-final=4 \
    --trainer.optimization.initial-effective-lrate=0.0003 \
    --trainer.optimization.final-effective-lrate=0.00003 \
    --trainer.optimization.shrink-value 0.99 \
    --trainer.rnn.num-chunk-per-minibatch=128,64 \
    --trainer.optimization.momentum=0.5 \
    --egs.chunk-width=$chunk_width \
    --egs.chunk-left-context=$chunk_left_context \
    --egs.chunk-right-context=$chunk_right_context \
    --egs.chunk-left-context-initial=0 \
    --egs.chunk-right-context-final=0 \
    --egs.dir="$common_egs_dir" \
    --cleanup.remove-egs=$remove_egs \
    --use-gpu=wait \
    --feat-dir=$train_data \
    --ali-dir=$ali_dir \
    --lang=$lang \
    --dir=$model_dir  || exit 1;
  echo "Finish training LSTM successfully!"
fi

