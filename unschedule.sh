#!/bin/bash

# Default values
l_flag=false
c_flag=false
u_flag=false
n_value=""
g_value=""


while getopts ":hlcun:g:p:" opt; do

  case $opt in
    h)
      echo "Usage:"
      echo ""
      echo "To cordon Nodepool"
      echo
      echo "./unschedule -g <value> -n <value> -p <value> -c"
      echo ""
      echo "              OR"
      echo ""
            echo "To Uncordon Nodepool"
      echo
      echo "./unschedule -g <value> -n <value> -p <value> -u"
      echo ""
      echo "              OR"
      echo ""
      echo "To list Nodepools"
      echo ""
      echo "./unschedule -g <value> -n <value> -l"
      echo ""
      echo "--------------------------------------------------"
      echo ""
      echo "-g     Resource Group of the cluster"
      echo "-n     Name of the Cluster"
      echo "-p     Name of the Nodepool"
      echo "-l     List nodepools"
      echo "-u     UnCordon nodepool"
      echo "-c     Cordon Nodepool"
      echo ""
      exit 0
      ;;
    g)
      g_value="$OPTARG"
      ;;
    n)
      n_value="$OPTARG"
      ;;
    p)
      p_value="$OPTARG"
      ;;
    l)
      l_flag=true
      ;;
    c)
      c_flag=true
      ;;
    u)
      u_flag=true
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
# Check if both -l, -u -c are provided
if  ${l_flag} && ${c_flag} ; then
  echo "Error: Only one of -l or -c or -u can be used at a time."
  exit 1
fi
if  ${l_flag} && ${u_flag}; then
  echo "Error: Only one of -l or -c or -u can be used at a time."
  exit 1
fi
if  ${c_flag} && ${u_flag}; then
  echo "Error: Only one of -l or -c or -u can be used at a time."
  exit 1
fi

# Run the appropriate command
if ${c_flag}; then
  echo "       Cordoning nodes now"
  echo "================================="
  echo ""
  for i in $(kubectl get nodes -o name | grep $p_value); do kubectl cordon $i ; done

elif  ${u_flag}; then
  echo "      Uncordoning nodes now"
  echo "================================="
  echo ""
  for i in $(kubectl get nodes -o name | grep $p_value); do kubectl uncordon $i ; done
elif ${l_flag}; then
  if [[ -z $g_value || -z $n_value ]]; then
   echo "Error: Both -n and -g are required when listing nodepools."
   exit 1
  fi

  echo "       Listing Nodepools"
  echo "================================="
  az aks nodepool list -g $g_value --cluster-name  $n_value -o json | jq '.[].name' --raw-output
else
  echo "Use -h for help."
fi
