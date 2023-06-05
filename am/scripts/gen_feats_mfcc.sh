. ./path.sh

if [ $# != 3 ]; then
  echo $#
  echo "usage:$0 wav.scp textfile targetdir"
  exit -1
fi

wav_scp=$1
text=$2
target_dir=$3

mfcc_config=../../config/feats/mfcc.conf
pitch_config=../../config//feats/pitch.conf
steps/gen_feats_mfcc_pitch.sh $wav_scp $text $mfcc_config $pitch_config $target_dir
