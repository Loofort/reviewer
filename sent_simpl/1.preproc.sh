#!/usr/bin/env bash
# the preprocessing runs about 20 minutes
# and take up to 4GB mem

OpenNMT=$HOME/work/projects/nlp/sent-simpl/OpenNMT-py
data=$(dirname $0)/data

source $OpenNMT/.env/bin/activate
python $OpenNMT/preprocess.py \
-save_data $data/preproc/baseline \
-train_src $data/train.complex \
-train_tgt $data/train.simple \
-valid_src $data/validation.complex \
-valid_tgt $data/validation.simple \
-src_seq_length 10000 \
-tgt_seq_length 10000 \
-src_seq_length_trunc 999 \
-tgt_seq_length_trunc 999 \
-dynamic_dict \
-share_vocab \
-max_shard_size 16777216 \
-src_vocab_size 1000000 \
-tgt_vocab_size 1000000
