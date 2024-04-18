#!/usr/bin/env bash

set -o errexit

inbase=/global/cfs/cdirs/dune/www/data/2x2/nearline/packet
plot_outbase=/global/cfs/cdirs/dune/www/data/2x2/nearline/hot_pixels/plots
log_outbase=/pscratch/sd/d/dunepr/logs/nearline/hot_pixels

inpath=$1; shift

get_outpath() {
    outbase=$1
    ext=$2

    indir=$(dirname "$inpath")
    reldir=$(echo "$indir" | sed "s|^$inbase/||")
    outname=$(basename "$inpath").hot_pixels.$ext
    echo "$outbase/$reldir/$outname"
}

plotpath=$(get_outpath "$plot_outbase" png)
logpath=$(get_outpath "$log_outbase" log)

cd "$(dirname "${BASH_SOURCE[0]}")/plot_hot_pixels"

if [[ "$(stat -c %s "$inpath")" -gt 10000000000 ]]; then
    echo "File is larger than 10 GB; bailing"
    exit 1
fi

mkdir -p "$(dirname "$plotpath")" "$(dirname "$logpath")"

./plot_hot_pixels.py --input_file "$inpath" --output_file "$plotpath" 2>&1 | tee "$logpath"
