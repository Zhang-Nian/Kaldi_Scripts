if [ $# != 5 ];then
  echo "usage:$0 wavfiles.list text.list mfcc.config pitch.conf targetDir";
  exit -1;
fi

wav_scp=$1;
text=$2
mfcc_config=$3
pitch_config=$4
mfcc_pitch_dir=$5

nj=72
compress=true
cmd=run.pl

raw_mfcc_pitch=$mfcc_pitch_dir/raw_mfcc_pitch
logdir=$5/log

mkdir -p $raw_mfcc_pitch || exit 1;
mkdir -p $logdir || exit 1;

name=$(basename $mfcc_pitch_dir)
delta_opts=
paste_length_tolerance=2
mfcc_feats="ark:compute-mfcc-feats --verbose=2 --config=$mfcc_config scp,p:$logdir/wav_${name}.JOB.scp ark:- | add-deltas $delta_opts ark:- ark:- |"
pitch_feats="ark:compute-kaldi-pitch-feats --verbose=2 --config=$pitch_config scp,p:$logdir/wav_${name}.JOB.scp ark:- | process-kaldi-pitch-feats --add-delta-pitch=false --add-pov-feature=false ark:- ark:- |"

split_scps=""
for n in $(seq $nj); do
  split_scps="$split_scps $logdir/wav_${name}.$n.scp"
done
utils/split_scp.pl $wav_scp $split_scps || exit 1;

$cmd JOB=1:$nj $logdir/make_mfcc_pitch_${name}.JOB.log \
  paste-feats --length-tolerance=$paste_length_tolerance "$mfcc_feats" "$pitch_feats" ark:- \| \
  copy-feats --compress=$compress $write_num_frames_opt ark:- \
    ark,scp:$raw_mfcc_pitch/raw_mfcc_pitch_$name.JOB.ark,$raw_mfcc_pitch/raw_mfcc_pitch_$name.JOB.scp || exit 1;

# concatenate the .scp files together.
for n in $(seq $nj); do
  cat $raw_mfcc_pitch/raw_mfcc_pitch_$name.$n.scp || exit 1;
done > $mfcc_pitch_dir/feats.scp || exit 1

cp $text $mfcc_pitch_dir/text

num_wav_scp=$(wc -l $mfcc_pitch_dir/feats.scp | cut -d ' ' -f 1)
num_text=$(wc -l $text | cut -d ' ' -f 1)

if [ $num_wav_scp -eq $num_text ]; then
  echo "$0: successfully prepared data in $mfcc_pitch_dir !"
else
  echo "Mismatch the count of wav_scp($num_wav_scp) vs. text($num_text) !"
  exit 1;
fi

exit 0
