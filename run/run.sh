
if [ $# != 4 ]; then
  echo "usage:$0 gmm_feats_dir gmm_target_models nn_feats_dir nn_target_models"
  exit -1;
fi

stage=0

gmm_feats_dir=$1
gmm_target_models=$2
nn_feats_dir=$3
nn_target_models=$4

if [ $stage -le 0 ]; then
  ./run_hmm_gmm.sh $gmm_feats_dir $gmm_target_models || exit -1;
fi

pdf_num=$(tree-info ${gmm_target_models}/tree | grep num-pdfs | awk '{print $2}')

mkdir -p $nn_target_models/configs
network_xconfig=$nn_target_models/configs/network.xconfig
cat <<EOF > $network_xconfig
input dim=40 name=input

lstmp-layer name=lstm1 input=input cell-dim=2048 recurrent-projection-dim=512
lstmp-layer name=lstm2 input=lstm1 cell-dim=2048 recurrent-projection-dim=512
affine-layer name=affine1 input=lstm2 dim=1024
affine-layer name=affine2 input=affine1 dim=1024

output-layer name=output input=affine2 dim=$pdf_num output-delay=0
EOF

if [ $stage -le 2 ]; then
  ./run_lstm.sh $nn_feats_dir $gmm_target_models $network_xconfig $nn_target_models || exit -1;
fi
