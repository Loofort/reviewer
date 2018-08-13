#!/bin/bash

if [ "$1" = "" ]; then
    echo "usage: script cid"
    echo "where cid is category id of https://oldnavy.gap.com/, e.g. 66124"
    exit
fi

# grab item list
site=data/oldnavy.gap.com
cid=$1
dir=./$site/category/$cid
file=$dir/cat.json
idfile=$dir/ids.txt

mkdir -p $dir
[ -e $file ] || wget -O $file https://oldnavy.gap.com/resources/productSearch/v1/search?cid=$cid&isFacetsEnabled=true&globalShippingCountryCode=us&globalShippingCurrencyCode=USD&locale=en_US&pageId=0&department=75
jq -r '.productCategoryFacetedSearch.productCategory.childCategories[].childProducts[].businessCatalogItemId' $file | sort -g | uniq > $idfile

# grab review for each item
rewdir=./$site/product
mkdir -p $rewdir

ids=($(cat $idfile))
for id in "${ids[@]}"
do
    mkdir -p $rewdir/$id
    rewfile=$rewdir/$id/0.json

    #[ -e $rewfile ] || wget -nv -O $rewfile "https://api.bazaarvoice.com/data/batch.json?passkey=68zs04f4b1e7jqc41fgx0lkwj&apiversion=5.5&displaycode=3755_31_0-en_us&resource.q0=products&filter.q0=id%3Aeq%3A$id&stats.q0=reviews&filteredstats.q0=reviews&filter_reviews.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_reviewcomments.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&resource.q1=reviews&filter.q1=isratingsonly%3Aeq%3Afalse&filter.q1=productid%3Aeq%3A$id&filter.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&sort.q1=submissiontime%3Adesc&stats.q1=reviews&filteredstats.q1=reviews&include.q1=authors%2Cproducts%2Ccomments&filter_reviews.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_reviewcomments.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_comments.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&limit.q1=10&offset.q1=0&limit_comments.q1=3"
    #cnt=$(jq -r '.BatchedResults.q1.TotalResults' $rewfile)
    bs=10
    ofs=0
    [ -e $rewfile ] || wget -nv -O $rewfile "https://api.bazaarvoice.com/data/batch.json?passkey=68zs04f4b1e7jqc41fgx0lkwj&apiversion=5.5&displaycode=3755_31_0-en_us&resource.q0=reviews&filter.q0=isratingsonly%3Aeq%3Afalse&filter.q0=productid%3Aeq%3A$id&filter.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&sort.q0=submissiontime%3Adesc&stats.q0=reviews&filteredstats.q0=reviews&include.q0=authors%2Cproducts%2Ccomments&filter_reviews.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_reviewcomments.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_comments.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&limit.q0=$bs&offset.q0=$ofs&limit_comments.q0=3"
    cnt=$(jq -r '.BatchedResults.q0.TotalResults' $rewfile)
    
    re='^[0-9]+$'
    if ! [[ $cnt =~ $re ]] ; then
        echo "error: cant get review count from $rewfile" >&2; exit 1
    fi
    echo "grabbing $cnt reviews for product $id"

    bs=50  # batch size
    for ((ofs=10; ofs<=$cnt; ofs+=bs)); do
        rfile=$rewdir/$id/$ofs.json
        [ -e $rfile ] || wget -nv -O $rfile "https://api.bazaarvoice.com/data/batch.json?passkey=68zs04f4b1e7jqc41fgx0lkwj&apiversion=5.5&displaycode=3755_31_0-en_us&resource.q0=reviews&filter.q0=isratingsonly%3Aeq%3Afalse&filter.q0=productid%3Aeq%3A$id&filter.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&sort.q0=submissiontime%3Adesc&stats.q0=reviews&filteredstats.q0=reviews&include.q0=authors%2Cproducts%2Ccomments&filter_reviews.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_reviewcomments.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_comments.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&limit.q0=$bs&offset.q0=$ofs&limit_comments.q0=3"
    done
done


#rewfile=$rewdir/{}.json
#cat $dir/ids.txt | xargs -I{} sh -c "test -e $rewfile || wget -O $rewfile 'https://api.bazaarvoice.com/data/batch.json?passkey=68zs04f4b1e7jqc41fgx0lkwj&apiversion=5.5&displaycode=3755_31_0-en_us&resource.q0=products&filter.q0=id%3Aeq%3A{}&stats.q0=reviews&filteredstats.q0=reviews&filter_reviews.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_reviewcomments.q0=contentlocale%3Aeq%3Aen_CA%2Cen_US&resource.q1=reviews&filter.q1=isratingsonly%3Aeq%3Afalse&filter.q1=productid%3Aeq%3A{}&filter.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&sort.q1=submissiontime%3Adesc&stats.q1=reviews&filteredstats.q1=reviews&include.q1=authors%2Cproducts%2Ccomments&filter_reviews.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_reviewcomments.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&filter_comments.q1=contentlocale%3Aeq%3Aen_CA%2Cen_US&limit.q1=10&offset.q1=0&limit_comments.q1=3&callback=BV._internal.dataHandler0' "
