#/bin/bash

# Scripts to make snapshoot of Sand based arista switch
# - drop counters (cpu, hw and plat)
# - arp/mac/hw ip route
# - clear counter
# 
# Usage(under Eos): $0 <dir> <tag>
# e.g.    Router# bash /mnt/flash/scripts/$0 2018.10.16 mlagReload

SECONDS=0
dir="/mnt/flash/$1"
tag="$2"

if [ ! -d "$dir" ]; then
	mkdir -p "$dir"
fi

echo "staring $0, dump drop counter under $dir with tag - $tag............"
FastCli -p 15 -c "show cpu counter queue summary"        > $dir/sh.cpu.cnt.qu.summ.$tag.txt
FastCli -p 15 -c "show cpu counter queue | nz"           > $dir/sh.cpu.cnt.qu.nz.$tag.txt
FastCli -p 15 -c "show hardware counter drop | nz"       > $dir/sh.hw.cnt.drop.nz.$tag.txt
FastCli -p 15 -c "show platform fap counters drops | nz" > $dir/sh.plat.fap.cnt.drop.nz.$tag.txt

echo "copying arp/mac under $dir with tag - $tag............"
FastCli -p 15 -c "show arp"                    > $dir/sh.arp.$tag.txt
FastCli -p 15 -c "show mac addr dyn"           > $dir/sh.mac.addr.dyn.$tag.txt
FastCli -p 15 -c "show mac addr mlag-peer dyn" > $dir/sh.mac.addr.mlag.dyn.$tag.txt
FastCli -p 15 -c "show platform fap ip route"  > $dir/sh.plat.fap.ip.route.$tag.txt
FastCli -p 15 -c "show mlag det"               > $dir/sh.mlag.det.$tag.txt
FastCli -p 15 -c "show mlag issu warn"         > $dir/sh.mlag.issu.warn.$tag.txt

echo "clearing counters........"
FastCli -p 15 -c "clear counter"
FastCli -p 15 -c "clear hardware counter drop"
FastCli -p 15 -c "clear platform fap counter"

echo "$0 is done, elapsed: $SECONDS sec"
