#!/bin/bash

if [ "$1" = "" ]; then
    echo "usage: script pid"
    echo "and pid is product id, e.g. 205604042"
    echo "example: ./show.sh 205604042 | jq '.[].ReviewText' | less"
    exit
fi

pid=$1
site=data/oldnavy.gap.com
products=./$site/product/$pid
dir=./$site/product/$pid
thefile=$dir/0.json

if [ ! -f $thefile ]; then
    echo "review file not found!"
    echo "probably you want to grab it first, see grab.sh"
    exit
fi

#jq -s '[ .[0].BatchedResults.q1.Results[], .[].BatchedResults.q0.Results[] ] | del(.[10]) ' $dir/*.json

find $products -name '*.json' -exec cat {} \; | jq -s '[.[].BatchedResults.q0.Results[]] | length'