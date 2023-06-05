echo "usage:$0 treedir"
echo "eg:$0 am/tree"
. ./path.sh
tree-info $1|grep num-pdfs
