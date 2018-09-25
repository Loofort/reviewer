#!/bin/bash

gitdir="$HOME/work/projects/nlp/sent-simpl"
data=$(dirname $0)/data
mkdir -p $data

# Web Split
webSplit="$gitdir/sprp-acl2018/data/baseline-seq2seq"
[ -d $webSplit ] || unzip -d $(dirname $webSplit) $webSplit.zip
cp $webSplit/{train.simple,train.complex} $data/

# Wiki Split
wikiSplit="$gitdir/wiki-split/train.tsv"
[ -e $wikiSplit ] || unzip -d $(dirname $wikiSplit) $wikiSplit.zip
awk -F'\t' '{print $1}' $wikiSplit >> $data/train.complex
awk -F'\t' '{print $2}' $wikiSplit | sed 's/ <::::>//g' >> $data/train.simple

validateCorp=$(dirname $wikiSplit)/validation.tsv
awk -F'\t' '{print $1}' $validateCorp > $data/validation.complex
awk -F'\t' '{print $2}' $validateCorp | sed 's/ <::::>//g' > $data/validation.simple

testCorp=$(dirname $wikiSplit)/tune.tsv
awk -F'\t' '{print $1}' $testCorp > $data/test.complex
awk -F'\t' '{print $2}' $testCorp | sed 's/ <::::>//g' > $data/test.simple

