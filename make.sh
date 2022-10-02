#!/bin/bash

#colors
W="\033[0;00m"
G="\033[0;92m"
R="\033[0;91m"
Y="\033[0;93m"

num_re='^[0-9]+$'

BUILD_DIR="./build"
CONFIG=RELEASE
run=yes
JOBS=
TARGET

opts=( "$@" )
for ((i=0;i<$#;i++));do
case "${opts[$i]}" in
  -clean)
    clean=true
    ;;
  -no-run)
    run=no
    ;;  
  -config)
    CONFIG=${opts[$((i+1))]}
    ((i++))
    ;;
  -B)
    BUILD_DIR="${opts[$((i+1))]}"
    ((i++))
    ;;
  -j)
    if [[ ${opts[$((i+1))]} =~ $num_re ]]
    then
    JOBS="-j ${opts[$((i+1))]}"
    ((i++))
    else
    JOBS="-j"
    fi
    printf "${Y}$JOBS${W}\n"
    ;;
  --target)
    TARGET="--target ${opts[$((i+1))]}"
    ((i++))
    ;;
  -h)
    printf "help:\n"
    printf "  -no-run                   build but don't run the app.\n"
    printf "  -clean                    build after removing previous build folder.\n"
    printf "  -config                   specify build type RELEASE, DEBUG ...\n"
    printf "  --target                  specify target.\n"
    printf "  -j                        Allow N jobs at once; infinite jobs with no arg.\n"
    exit 0
    ;;
  *)
    printf "\"${opts[$((i))]}\" is invalid option, -h for help.\n"
    exit 1
    ;;
esac
done

if [[ $clean ]]
then
  printf "${Y}-- Removing build${W}\n"
  rm -rf $BUILD_DIR
  if [[ $? -eq 1 ]]
  then
    printf "${R}-- Clean Error: Build folder not found $BUILD_DIR.${W}\n" && \
    exit 1
  fi
fi

cmake -B $BUILD_DIR -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DCMAKE_BUILD_TYPE=$CONFIG
if [[ $? -eq 1 ]]
then
  printf "${R}-- Cmake failed${W}\n" && \
  exit 1
fi

cmake --build $BUILD_DIR $TARGET install $JOBS 
if [[ $? -eq 0 ]]
then
  printf "${G}-- Build successful.${W}\n"
  if [[ $run == yes ]]
  then
    printf "${G}-- Running Application.${W}\n\n"
    ./run.sh
  fi
  exit 0
else
  printf "${R}-- Build failed.${W}\n" && \
  exit 1
fi