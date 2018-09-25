#!/usr/bin/env bash

OpenNMT=$HOME/work/projects/nlp/sent-simpl/OpenNMT-py
data=$(dirname $0)/data
model_name=sprp_onmt_copy_512

source $OpenNMT/.env/bin/activate
python $OpenNMT/train.py \
-save_model $data/model/$model_name \
-data $data/preproc/baseline \
-copy_attn \
-copy_attn_force \
-global_attention mlp \
-word_vec_size 512 \
-rnn_size 512 \
-layers 1 \
-encoder_type brnn \
-train_steps 30 \
-seed 777 \
-batch_size 64 \
-max_grad_norm 2 \
-share_embeddings 
#-gpuid 0 
#-start_checkpoint_at 1 \

