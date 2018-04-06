#!/usr/bin/env bash

# arr_1: wish list
# arr_2: installed list
function checkInstall {
	declare -a argv=("${@}")                           # All arguments in one big array
	declare -i len_1=${argv[0]}                        # Length of first array passad
	declare -a arr_1=("${argv[@]:1:$len_1}")           # First array
	declare -i len_2=${argv[(len_1 + 1)]}              # Length of second array passad
	declare -a arr_2=("${argv[@]:(len_1 + 2):$len_2}") # Second array
	declare -i totlen=${#argv[@]}                      # Length of argv array (len_1+len_2+2)
	declare __ret_array_name=${argv[(totlen - 1)]}     # Name of array to be returned
  # declare -a argc="$@"

	for package in "${arr_1[@]}"
	do
		if [[ ! " ${arr_2[@]} " =~ " ${package} " ]]; then
			# whatever you want to do when arr doesn't contain value
			echo "install ${package}..."
			brew install ${package}
		fi
		if [[ " ${arr_2[@]} " =~ " ${package} " ]]; then
			# whatever you want to do when arr contains value
			echo "upgrade ${package}..."
			brew upgrade ${package}
		fi
	done
}

function optTest {
  local TMP_OPTIND=$OPTIND
  OPTIND=1
  # echo -e "\n+ testGetOpts1() $@"

  while getopts  "i:e:u:" flag
  do
    case $flag in
      i)
        wishList=("$OPTARG")
        until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z $(eval "echo \${$OPTIND}") ]; do
            wishList+=($(eval "echo \${$OPTIND}"))
            OPTIND=$((OPTIND + 1))
        done
        ;;
      e)
        installed=("$OPTARG")
        until [[ $(eval "echo \${$OPTIND}") =~ ^-.* ]] || [ -z $(eval "echo \${$OPTIND}") ]; do
            installed+=($(eval "echo \${$OPTIND}"))
            OPTIND=$((OPTIND + 1))
        done
        ;;
      u)
        update=$OPTARG
        ;;
    esac
    # echo "$flag" IND=$OPTIND ARG=$OPTARG
  done
  # echo  OPTIND=$OPTIND
  # echo ""
  echo "${wishList[@]}"
  echo "${installed[@]}"
  OPTIND=$TMP_OPTIND
}
