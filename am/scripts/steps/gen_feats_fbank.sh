if [ $# != 4 ];then
  echo "usage:$0 wavfiles.list text.list fbank.conf targetDir";
  exit -1;
fi

wav_scp=$1;
text=$2
fbank_config=$3
fbank_dir=$4

nj=72
compress=true
cmd=run.pl

raw_fbank=$fbank_dir/raw_fbank
logdir=$4/log

mkdir -p $raw_fbank || exit 1;
mkdir -p $logdir || exit 1;

name=$(basename $fbank_dir)
delta_opts=

split_scps=""
for n in $(seq $nj); do
  split_scps="$split_scps $logdir/wav_${name}.$n.scp"
done
utils/split_scp.pl $wav_scp $split_scps || exit 1;

$cmd JOB=1:$nj $logdir/make_fbank_${name}.JOB.log \
  compute-fbank-feats  --verbose=2 --config=$fbank_config \
   scp,p:$logdir/wav_${name}.JOB.scp ark:- \| \
    copy-feats --compress=$compress ark:- \
      ark,scp:$raw_fbank/raw_fbank_$name.JOB.ark,$raw_fbank/raw_fbank_$name.JOB.scp || exit 1;

# concatenate the .scp files together.
for n in $(seq $nj); do
  cat $raw_fbank/raw_fbank_$name.$n.scp || exit 1;
done > $fbank_dir/feats.scp || exit 1

cp $text $fbank_dir/text

num_wav_scp=$(wc -l $fbank_dir/feats.scp | cut -d ' ' -f 1)
num_text=$(wc -l $text | cut -d ' ' -f 1)

if [ $num_wav_scp -eq $num_text ]; then
  echo "$0: successfully prepared data in $fbank_dir !"
else
  echo "Mismatch the count of wav_scp($num_wav_scp) vs. text($num_text) !"
  exit 1;
fi

exit 0
