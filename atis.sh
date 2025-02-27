#!/bin/bash

atis(){
  hostname="atis"
  remotePath="Schreibtisch"
  printer="pool-sw3"
  mode="two-sided-long-edge" # Standard Duplex

  # Check if file specified
  if [ -z "${1}" ]
  then
    echo "=> No file name specified. Aborting." > /dev/stderr
    return 1
  fi

  # Check if correct printer specified
  if [ -n "${2}" ]
  then
    case $2 in
      pool-sw1|pool-sw2|pool-sw3|pool-farb1) 
        printer=$2;;
      sw1|sw2|sw3|farb1) 
        printer=pool-$2;;
      *) 
        echo "=> Invalid printer. Printing on default printer '$printer'" > /dev/stderr;;
    esac
  fi

  # Check if print mode is specified
  if [ -n "${3}" ]
  then
    case $3 in
      one-sided|two-sided-long-edge|two-sided-short-edge) 
        mode=$3;;
      duplex) 
        ;; # already default
      simplex)
        mode=one-sided;;
      *) 
        echo "=> Invalid print mode. Printing with default print mode '$mode'" > /dev/stderr;;
    esac
  fi

  filename=$( basename "$1" )
  
  if < "$1" | (command -v pv > /dev/null && pv || cat) | ssh $hostname "lpr -P $printer -o sides=$mode -"
  then
    echo "=> Printed file '$filename' successfully on printer '$printer' with print mode '$mode'."
  else
    echo "=> Printing failed." > /dev/stderr
    return 1
  fi
}
