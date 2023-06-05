


. ./path.sh

data=$1
numsplit=$2

directories=$(for n in `seq $numsplit`; do echo $data/split${numsplit}/$n; done)

# if this mkdir fails due to argument-list being too long, iterate.
if ! mkdir -p $directories >&/dev/null; then
  for n in `seq $numsplit`; do
    mkdir -p $data/split${numsplit}/$n
  done
fi

feats_list=$(for n in `seq $numsplit`; do echo $data/split${numsplit}/$n/feats.scp; done)
text_list=$(for n in `seq $numsplit`; do echo $data/split${numsplit}/$n/text; done)
# utt2spk_list=$(for n in `seq $numsplit`; do echo $data/split${numsplit}/$n/utt2spk; done)

utils/split_scp.pl $data/feats.scp $feats_list || exit 1
utils/split_scp.pl $data/text $text_list || exit 1
# utils/split_scp.pl $data/utt2spk $utt2spk_list || exit 1

echo "successfully finish splitting feature data!"

