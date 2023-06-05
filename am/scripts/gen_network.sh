. ./path.sh

if [ $# != 2 ];then
  echo "usage:$0 xconfig modeldir"
  exit -1;
fi

config_file=$1
model_dir=$2

./steps/nnet3/xconfig_to_configs.py --xconfig-file $config_file --config-dir $model_dir 
