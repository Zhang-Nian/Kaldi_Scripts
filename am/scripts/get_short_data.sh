
short_num=$1
feats_dir=$2
short_feats_dir=$3

if [ $# != 3 ]; then
  echo "usage:$0 short_num feats_dir short_feats_dir."
  exit -1;
fi

mkdir -p $short_feats_dir || exit 1;

# preparing top short_num data for training mono model
feat-to-len scp:$feats_dir/feats.scp ark,t:$short_feats_dir/tmp.len || exit 1;

sort -n -k2 $short_feats_dir/tmp.len | awk '{print $1}' | head -$short_num >$short_feats_dir/short_data.list

utils/filter_data.py $short_feats_dir/short_data.list $feats_dir $short_feats_dir || exit 1;
# rm $short_feats_dir/tmp.len $short_feats_dir/short_data.list

