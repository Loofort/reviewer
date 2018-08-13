#!/bin/bash

site=data/oldnavy.gap.com
#products=./$site/product/116924002
products=./$site/product/
#find $products -name '*.json' -exec cat {} \; | jq -s '.[].BatchedResults.q0.Results[]'
#find $products -name '*.json' -exec cat {} \; | jq -s '.[] | [.BatchedResults?]'
#find $products -name '*.json' -type f -exec jq -s '.[].BatchedResults.q0.Results[]' {} \+
#find $products -name '*.json' -type f -print0 | xargs -0 cat | jq -s '.[].BatchedResults.q0.Results[]'
#find $products -name '*.json' -type f -print0 | xargs -0 cat | jq -s '.[]'
#find $products -name '*.json' -type f -exec cat {} \+ | jq -s '.[].BatchedResults.q0.Results[]'
#find $products -name '*.json' -type f -exec jq '.BatchedResults.q0.Results[]' {} \; 

find $products -name '*.json' -type f -print0 | xargs -n1 -0 jq '.BatchedResults.q0.Results[] | select(.Rating <= 3) | .ReviewText' | sort| uniq

