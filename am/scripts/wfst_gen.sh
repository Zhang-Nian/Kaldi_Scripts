. ./path.sh

if [ $# != 4 ]; then
  echo "usage:$0 amdir lmfile dictdir targetdir"
  exit -1
fi

am_model_dir=$1
lm=$2
dict_dir=$3
target_dir=$4

wfst_dir=$target_dir/wfst.final
lang=$target_dir/lang
./utils/prepare_lang.sh $dict_dir '<UNK>' $lang.tmp $lang
rm -rf $lang.tmp
lang_wfst=$target_dir/lang_wfst
./utils/format_lm.sh $lang $lm $dict_dir/lexicon.txt $lang_wfst
./utils/mkgraph.sh $lang_wfst $am_model_dir $wfst_dir
