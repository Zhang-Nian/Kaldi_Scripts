. ../cmd.sh
. ../path.sh
wfst=/data/kanghuanping/kaldi/egs/vipkid_asr/s5/wfst.final
../steps/nn_decode.sh --nj 72 $wfst /data/vipkid_feats/test_set/fbank/mini_librispeech /data/kanghuanping/kaldi/egs/vipkid_asr/s5/exp/lib_ted_tim_lstm_fbank/decode_mini_librispeech
