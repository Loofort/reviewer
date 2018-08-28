#!/bin/bash

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

help() {
    printf "usage: ./list.sh [args]\n"
    printf "  -s, --stars <stars>\n"
    printf "    return reviews with rating <= stars, if not set stars=5 \n\n"
    printf "  -p, --pid <product_id>\n"
    printf "    return reviews for particlur product id, e.g. 116924002 \n\n"
}

products=./data/oldnavy.gap.com/product
dir=$products
stars=
pid=

while :; do
    case $1 in
        -h|-\?|--help)
            help    # Display a usage synopsis.
            exit
            ;;
        -s|--stars)
            if [ "$2" ]; then
                stars=$2
                shift
            else
                die 'ERROR: "'$1'" requires a non-empty option argument'
            fi
            ;;
        -p|--pid)
            if [ "$2" ]; then
                pid=$2
                shift
                dir=$dir/$pid
                if [ ! -f $dir/0.json ]; then
                    echo "review file not found for product $1"
                    echo "probably you want to grab it first, see grab.sh"
                    exit
                fi
            else
                die 'ERROR: "'$1'" requires a non-empty option argument'
            fi
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac
    shift
done

find $dir -name '*.json' -type f -print0 | xargs -n1 -0 jq -r ".BatchedResults.q0.Results[] | select(.Rating <= $stars ) | .ReviewText" | sort| uniq 