#!/bin/bash 

qbinary=/data/work/q_source/bin/qdyn5
wd=`pwd`

#set -e
if [ -z $qbinary ]
then 
 echo "Please set the qbinary variable to point to the Q folder"
 exit 1
elif [ ! -x $qbinary ]
then
 echo "Can't locate qdyn in the $qbinary variable, or you don't have 
       execute permisson."
 exit 1
else
 echo "Detected qdyn in ${QDIR}"
fi

rm -rf $wd/run-nompitest
mkdir $wd/run-nompitest
cp *inp eval_test.sh qsurr_benchmark.en $wd/run-nompitest
ln -s $wd/prep/lig_w.top $wd/run-nompitest/lig_w.top
ln -s $wd/prep/lig_w.fep $wd/run-nompitest/lig_w.fep
  
cd $wd/run-nompitest


rm -f eq{1..5}.log dc{1..5}.log >& /dev/null

# Useful vars
OK="(\033[0;32m   OK   \033[0m)"
FAILED="(\033[0;31m FAILED \033[0m)"

for step in {1..5}
do
 echo -n "Running equilibration step ${step} of 5                         "
 if $qbinary eq${step}.inp > eq${step}.log
 then echo -e "$OK"
 else 
  echo -e "$FAILED"
  echo "Check output (eq${step}.log) for more info."
  exit 1
 fi
done

for step in {1..5}
do
 echo -n "Running production run step ${step} of 5                        "
 if $qbinary dc${step}.inp > dc${step}.log
  then echo -e "$OK"
 else 
  echo -e "$FAILED"
  echo "Check output (dc${step}.log) for more info."
  exit 1
 fi
done


