#! /bin/bash


# find classification files
find output/ -name classification.txt | while read CLASSIFICATION; do

  # count number of CAZymes from each class. Note that they can overlap, e.g., GH13+CBM20
  GH=$(grep -c GH $CLASSIFICATION)
  AA=$(grep -c AA $CLASSIFICATION)
  GT=$(grep -c GT $CLASSIFICATION)
  PL=$(grep -c PL $CLASSIFICATION)
  CE=$(grep -c CE $CLASSIFICATION)
  CBM=$(grep -c CBM $CLASSIFICATION)

  ISOLATE=$(echo $CLASSIFICATION | awk -v FS="/" '{print $2}')
  echo $ISOLATE$'\t'GH$'\t'$GH
  echo $ISOLATE$'\t'GT$'\t'$GT
  echo $ISOLATE$'\t'PL$'\t'$PL
  echo $ISOLATE$'\t'CE$'\t'$CE
  echo $ISOLATE$'\t'CBM$'\t'$CBM
  echo $ISOLATE$'\t'AA$'\t'$AA
done
