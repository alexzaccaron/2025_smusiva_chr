#! /bin/bash


# download files from dbCAN webserver results
# It worked when I selected all boxes in the submission form: run all tools, plus CGCFinder, plus Substrate Prediction with dbCAN-PUL and dbCAN-sub
# when done, there will be an ID of the run
ID=$1

wget \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/overview.txt \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/hmmer.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/diamond.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/dbsub.out
mkdir GCG_finder
cd GCG_finder/
wget \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/cgc_standard.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/tp.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/tf-1.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/tf-2.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/stp.out \
https://bcb.unl.edu/dbCAN2/data/blast/$ID/sub.prediction.out
