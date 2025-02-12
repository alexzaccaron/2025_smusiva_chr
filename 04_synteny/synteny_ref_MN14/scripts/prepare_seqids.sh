cat input/order.txt | \
     while read ISOLATE; do
        grep -v ^# input/${ISOLATE}.gff | cut -f 1 | uniq | tr '\n' ','; echo ""
     done | sed 's/,$//g'
