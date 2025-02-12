#! /bin/bash


echo "# y, xstart, xend, rotation, color, label, va,  bed"
cat input/order.txt  | awk -v OFS="," -v x=0.95 '{print "."substr(x,3,5),".1", ".9", 0, " ",$1,"top", "output/"$1".bed"; x=x-0.05}'
echo "# edges"
head -n -1 input/order.txt | while read ID; do ls output/${ID}.*anchors.simple; done | awk -v OFS="," '{print "e",NR-1,NR,$0}'
