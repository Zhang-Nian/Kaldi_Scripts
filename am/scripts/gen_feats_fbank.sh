. ./path.sh

if [ $# != 3 ]; then
  echo "usage:$0 wav.scp textfile targetdir"
  exit -1
fi

wav_scp=$1
text=$2
target_dir=$3

fbank_config=../../config/feats/fbank.conf
steps/gen_feats_fbank.sh $wav_scp $text $fbank_config $target_dir
